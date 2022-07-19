import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/flutter_login.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
            }, child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}