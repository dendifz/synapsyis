import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsyis/ui/dashboard/flutter_dashboard.dart';
import 'package:synapsyis/ui/login/flutter_login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(MaterialApp(home: email == null ? const LoginScreen() : const DashboardScreen()));
}