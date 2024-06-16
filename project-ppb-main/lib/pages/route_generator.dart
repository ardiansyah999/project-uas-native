import 'package:flutter/material.dart';
import 'package:quantum_stock/pages/delete_page.dart';
import 'package:quantum_stock/pages/error_page.dart';
import 'package:quantum_stock/pages/login_page.dart';
import 'package:quantum_stock/pages/logout_page.dart';
import 'package:quantum_stock/pages/utama.dart';
import 'package:quantum_stock/pages/add_page.dart';
import 'package:quantum_stock/pages/edit_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/add':
        return MaterialPageRoute(builder: (_) => AddPage());
      case '/edit':
        return MaterialPageRoute(builder: (_) => EditPage());
      case '/delete':
        return MaterialPageRoute(builder: (_) => DeletePage());
      case '/logout':
        return MaterialPageRoute(builder: (_) => LogoutPage());
      // case '/default':
      // Tambahkan page default di sini
      default:
        return MaterialPageRoute(builder: (_) => const ErrorPage());
    }
  }
}
