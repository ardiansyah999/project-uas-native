import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "package:quantum_stock/pages/route_generator.dart";

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  int _selectedIndex = 0; // Tambahkan variabel untuk menyimpan indeks terpilih
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  var formatter = NumberFormat.decimalPatternDigits(
    locale: 'id_ID',
    decimalDigits: 0,
  );

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        // Navigator.pushNamed(context, '/add');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/edit');
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
          title: Center(child: const Text('Add Products')),
        ),
        body: StreamBuilder(
          stream: _products.orderBy('timestamp', descending: true).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantity: ${documentSnapshot['quantity']}"),
                          Text(
                              "Timestamp: ${_formatTimestamp(documentSnapshot['timestamp'])}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        floatingActionButton: FloatingActionButton(
          onPressed: _createProduct,
          child: const Icon(Icons.add),
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

  Future<void> _createProduct() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
              ),
              TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Create'),
                onPressed: () async {
                  final String? name = _nameController.text;
                  final int? quantity = int.tryParse(_quantityController.text);
                  if (name != null && quantity != null) {
                    await _products.add({
                      "name": name,
                      "quantity": quantity,
                      "timestamp": FieldValue.serverTimestamp(),
                    });

                    _nameController.text = '';
                    _quantityController.text = '';

                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat.yMMMd().add_Hms().format(dateTime);
    }
    return 'Timestamp not available';
  }
}
