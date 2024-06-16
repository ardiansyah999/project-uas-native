import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantum_stock/pages/route_generator.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({Key? key}) : super(key: key);

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  int _selectedIndex = 2; // Tambahkan variabel untuk menyimpan indeks terpilih
  final TextEditingController _searchController = TextEditingController();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  late String _selectedProductId;
  List<DocumentSnapshot> _filteredProducts = [];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/add');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/edit');
        break;
      case 2:
        // Navigator.pushReplacementNamed(context, '/delete');
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
          title: Center(child: Text('Delete Products')),
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
                          _editProduct(document.id);
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

  void _editProduct(String productId) {
    setState(() {
      _selectedProductId = productId;
    });

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete this product?'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _deleteProduct();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Change the button color to red
                ),
                child: Text('Delete Product'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteProduct() {
    _products.doc(_selectedProductId).delete();

    setState(() {
      _selectedProductId = '';
      _searchController.clear();
      _filterProducts('');
    });

    Navigator.of(context).pop(); // Close the bottom sheet
  }
}

void main() {
  runApp(MaterialApp(
    home: DeletePage(),
  ));
}
