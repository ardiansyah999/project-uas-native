import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantum_stock/pages/route_generator.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  int _selectedIndex = 1; // Tambahkan variabel untuk menyimpan indeks
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _editedNameController = TextEditingController();
  final TextEditingController _editedQuantityController =
      TextEditingController();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  bool _editing = false;
  late String _selectedProductId;
  List<DocumentSnapshot> _filteredProducts = [];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/add');
        break;
      case 1:
        // Navigator.pushReplacementNamed(context, '/edit');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/delete');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('List Products')),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterProducts('');
                    },
                  ),
                ),
                onChanged: (value) {
                  _filterProducts(value);
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: _products.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final products = _filteredProducts.isNotEmpty
                      ? _filteredProducts
                      : snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final document = products[index];

                      return ListTile(
                        title: Text(document['name']),
                        subtitle: Text('Quantity: ${document['quantity']}'),
                        onTap: () {
                          _editProduct(document.id, document['name'],
                              document['quantity']);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        endDrawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  subtitle: const Text("Back to Home Page"),
                  onTap: () {
                    Navigator.pop(
                        context, '/'); // Kembali ke halaman sebelumnya
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  subtitle: const Text("Exit to Login Page"),
                  onTap: () {
                    Navigator.pushNamed(context, '/logout');
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: "Add",
              //backgroundColor: _selectedIndex == 0 ? Colors.blue : null,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: "Edit",
              //backgroundColor: _selectedIndex == 1 ? Colors.blue : null,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete),
              label: "Delete",
              //backgroundColor: _selectedIndex == 2 ? Colors.blue : null,
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap:
              _onItemTapped, // Gunakan method _onItemTapped sebagai handler onTap
        ),
      ),
    );
  }

  // Fungsi untuk melakukan pencarian
  void _search(String query) {
    query = query.toLowerCase();
    setState(() {
      _filteredProducts = _filteredProducts
          .where((document) => document['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  void _filterProducts(String keyword) {
    _products
        .where('name', isGreaterThanOrEqualTo: keyword)
        .where('name', isLessThan: keyword + 'z')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _filteredProducts = querySnapshot.docs.toList();
      });
    });
  }

  void _editProduct(String productId, String name, int quantity) {
    setState(() {
      _editing = true;
      _selectedProductId = productId;
      _editedNameController.text = name;
      _editedQuantityController.text = quantity.toString();
      _searchController.clear();
      _filterProducts('');
    });

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editedNameController,
                decoration: InputDecoration(labelText: 'Edit Nama Barang'),
              ),
              TextField(
                controller: _editedQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Edit Jumlah'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _updateProduct();
                },
                child: Text('Update Product'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateProduct() {
    final String editedName = _editedNameController.text;
    final int editedQuantity =
        int.tryParse(_editedQuantityController.text) ?? 0;

    if (editedName.isNotEmpty) {
      _products.doc(_selectedProductId).update({
        'name': editedName,
        'quantity': editedQuantity,
      });

      setState(() {
        _editing = false;
        _selectedProductId = '';
        _editedNameController.clear();
        _editedQuantityController.clear();
        _searchController.clear();
        _filterProducts(''); // Perubahan di sini
      });

      Navigator.of(context).pop(); // Close the bottom sheet
    }
  }
}
