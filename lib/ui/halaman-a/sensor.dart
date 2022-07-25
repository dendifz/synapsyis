import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sensor extends StatefulWidget {
  const Sensor({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _Sensor createState() => _Sensor();
}

class _Sensor extends State<Sensor> {
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  String? _timeString;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  late Timer timer;
  late var iTimer = 10;

  Future _getRefreshRate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    iTimer = prefs.getInt('timer')!;
  }

  Future<int?> _bateryLevel() async {
    return (await BatteryInfoPlugin().androidBatteryInfo)?.batteryLevel;
  }

  @override
  Widget build(BuildContext context) {
    final timeString = _timeString;
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Halaman A'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$timeString'),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(
                    children: [
                      Column(
                        children: const [
                          Text(
                            'Type Sensor',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            'x, y, z',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Column(
                        children: const [Text('Accelerometer')],
                      ),
                      Column(
                        children: [Text('$accelerometer')],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Column(
                        children: const [Text('UserAccelerometer')],
                      ),
                      Column(
                        children: [Text('$userAccelerometer')],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Column(
                        children: const [Text('Gyroscope')],
                      ),
                      Column(
                        children: [Text('$gyroscope')],
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Column(
                        children: const [
                          Text('Magnetometer'),
                        ],
                      ),
                      Column(
                        children: [Text('$magnetometer')],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Text("Battery Level: ${_bateryLevel()}")
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    timer.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy hh:mm:ss').format(dateTime);
  }

  void subcriptionInfo() {
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(
            () {
              _accelerometerValues = <double>[event.x, event.y, event.z];
            },
          );
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(
            () {
              _gyroscopeValues = <double>[event.x, event.y, event.z];
            },
          );
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(
            () {
              _userAccelerometerValues = <double>[event.x, event.y, event.z];
            },
          );
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(
            () {
              _magnetometerValues = <double>[event.x, event.y, event.z];
            },
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _getRefreshRate();

    _timeString = _formatDateTime(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());

    timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => subcriptionInfo());
  }
}
