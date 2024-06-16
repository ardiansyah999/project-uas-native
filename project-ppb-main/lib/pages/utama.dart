import 'package:flutter/material.dart';
import 'package:quantum_stock/pages/route_generator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Quantum Stock"),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Colors.amber[800],
                    child: InkWell(
                      splashColor: Colors.amber[800],
                      onTap: () {
                        Navigator.pushNamed(context, '/add');
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.add,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.amber[800],
                    child: InkWell(
                      splashColor: Colors.amber[800],
                      onTap: () {
                        Navigator.pushNamed(context, '/edit');
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.edit,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Material(
                    color: Colors.amber[800],
                    child: InkWell(
                      splashColor: Colors.amber[800],
                      onTap: () {
                        Navigator.pushNamed(context, '/delete');
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.delete,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.amber[800],
                    child: InkWell(
                      splashColor: Colors.amber[800],
                      onTap: () {
                        Navigator.pushNamed(context, '/logout');
                      },
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.logout,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        endDrawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text("Logout"),
                  subtitle: const Text("Exit to login page"),
                  onTap: () {
                    Navigator.pushNamed(context, '/logout');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
