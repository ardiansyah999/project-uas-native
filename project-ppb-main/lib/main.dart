import 'package:flutter/material.dart';
//import 'package:uas/screens/home.dart';
import 'package:quantum_stock/pages/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:quantum_stock/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: '/',
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text("Quantum Stock"),
      //     centerTitle: true,
      //   ),
      // ),
    );
  }
}
