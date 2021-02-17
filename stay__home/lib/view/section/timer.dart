import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/main.dart';
import 'package:stay__home/service/databaseHelper.dart';

class SectionTimer extends StatefulWidget {
  SectionTimer({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SectionTimerState createState() => new _SectionTimerState();
}

class _SectionTimerState extends State<SectionTimer> {
  Isolate _isolate;
  bool _running = false;

  bool isHome = false;

  static int _counter = 0;
  double second = 0;
  double day = 0;
  double hour = 0;
  double minute = 0;
  double count = 0;
  String noti;

  ReceivePort _receivePort;

  var locationController = Get.put(LocationController());
  var userController = Get.put(UserController());
  var dbController = DBController();

  @override
  void initState() {
    _start();
    _running = true;
    dbController.onInit();
    super.initState();
  }

  void _start() async {
    _running = true;
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_checkTimer, _receivePort.sendPort);
    _receivePort.listen(_handleMessage, onDone: () {
      print("done!");
    });
  }

  static void _checkTimer(SendPort sendPort) async {
    Timer.periodic(new Duration(seconds: 1), (Timer t) async {
      _counter++;
      String msg = 'notification ' + _counter.toString();
      print('SEND: ' + msg);
      sendPort.send(msg);
    });
  }

  void _handleMessage(dynamic data) async {
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await dbController.user().then((value) {
      if (userLocation.latitude > value[0].latitude + 0.00100 ||
          userLocation.latitude < value[0].latitude - 0.00100 ||
          userLocation.longitude > value[0].longitude + 0.00100 ||
          userLocation.longitude < value[0].longitude - 0.00100) {
        print("집이 아닙니다.");
        isHome = false;
      } else {
        print("집입니다.");
        isHome = true;
      }
    });

    print('RECEIVED: ' + data);

    if (isHome) {
      setState(() {
        noti = data;
        count++;
        second = count;

        minute = count / 60;
        hour = minute / 60;
        day = hour / 24;

        hour %= 24;
        minute %= 60;
        second %= 60;
      });
    } else {
      setState(() {
        second = 0;
        count = 0;
      });
    }
  }

  void _stop() {
    if (_isolate != null) {
      setState(() {
        _running = false;
        second = 0;
      });
      _receivePort.close();
      _isolate.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  sendData() {}

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "${day.toInt()}일 ${hour.toInt()}시간 ${minute.toInt()}분 ${second.toInt()}초",
          ),
        ],
      ),
    );
  }
}
