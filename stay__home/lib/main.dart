import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/screens/myHomePage.dart';
import 'package:workmanager/workmanager.dart';
import 'util/localNotification.dart' as notif;

import 'controller.dart';

const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  final controller = Get.put(Controller());

  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        //Geolocator geoLocator = Geolocator()..forceAndroidLocationManager = true;
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        notif.Notification notification = new notif.Notification();
        notification.showNotificationWithoutSound(userLocation);
        controller.checkLocationParams(
            userLocation.latitude, userLocation.longitude);
        print("안머아ㅣㅁ너아ㅓ아ㅓㅏㅇ");
        break;
      default:
        controller.determinePosition();
        break;
    }
    return Future.value(true);
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
