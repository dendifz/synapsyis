import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synapsyis/ui/halaman-b/device-info.dart';

class HalamanB extends StatefulWidget {
  const HalamanB({Key? key}) : super(key: key);

  @override
  _HalamanB createState() => _HalamanB();
}

class _HalamanB extends State<HalamanB> {
  TextEditingController etTimer = TextEditingController();

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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DeviceInfo(),
                  ),
                );
              },
              child: const Text('Device Info'),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: TextField(
                controller: etTimer,
                decoration: const InputDecoration(hintText: '1-30'),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt('timer', int.parse(etTimer.text));
                const SimpleDialog(title: Text('Saving...'));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
