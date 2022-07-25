import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsyis/ui/dashboard/flutter_dashboard.dart';
import 'package:synapsyis/ui/login/local_auth.dart';

import '../../utils/color.dart';

const users = {
  'dendizaman@gmail.com': 'aku123',
};

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return data.name;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius inputBorder = BorderRadius.circular(15);

    return FlutterLogin(
      title: 'Connect Everything',
      logo: const AssetImage('assets/images/logo.png'),
      onLogin: (data) async {
        _authUser(data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', data.name);
        return null;
      },
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        primaryColor: backgroundColor,
        accentColor: secondaryColor,
        titleStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: primaryColor,
        ),
        cardTheme: CardTheme(
            margin: const EdgeInsets.only(top: 15), color: primaryColor),
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 12),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 2),
            borderRadius: inputBorder,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 3),
            borderRadius: inputBorder,
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 5),
            borderRadius: inputBorder,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 6),
            borderRadius: inputBorder,
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 0),
            borderRadius: inputBorder,
          ),
        ),
        buttonTheme: LoginButtonTheme(
          splashColor: Colors.purple,
          backgroundColor: secondaryColor,
          highlightColor: Colors.lightGreen,
          elevation: 9.0,
          highlightElevation: 6.0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      messages: LoginMessages(
        userHint: 'Email address',
        recoverPasswordDescription:
            'We\'ll send you a link to reset your password',
        recoveryCodeHint: 'Recovery code',
      ),
      loginProviders: [
        LoginProvider(
          icon: Icons.fingerprint,
          animated: true,
          callback: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LocalAuth(),
            ));
          },
        ),
        LoginProvider(
          icon: Icons.facebook,
          callback: () {},
        ),
      ],
    );
  }
}
