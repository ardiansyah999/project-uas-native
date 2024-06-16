// logout_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quantum_stock/auth.dart';

class LogoutPage extends StatelessWidget {
  LogoutPage({Key? key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await Auth().signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/',
          (Route<dynamic> route) => false); // Navigate back to the login page
    } catch (e) {
      // Handle sign-out error (e.g., display an error message)
      print('Sign-out error: $e');
    }
  }

  Widget _buildTitle() {
    return const Text('Yakin ingin Keluar?',
        style: TextStyle(
          color: Colors.black,
        ));
  }

  Widget _buildUserUid(User? user) {
    return Text(user?.email ?? 'User email');
  }

  Widget _buildSignOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _signOut(context),
      style: ElevatedButton.styleFrom(
        primary: Colors.amber[800],
      ),
      child: const Text("Sign Out"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<User?>(
          stream: Auth().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              User? user = snapshot.data;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildUserUid(user),
                  _buildSignOutButton(context),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
