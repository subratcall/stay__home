import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:stay__home/screens/myHomePage.dart';
import 'package:stay__home/util/localNotification.dart';
import 'package:workmanager/workmanager.dart';
import 'util/localNotification.dart' as notif;

import 'controller.dart';

const fetchBackground = "fetchBackground";

void callbackDispatcher() {
  final controller = Get.put(Controller());

  Workmanager.executeTask((task, inputData) async {
    // switch (task) {
    //   case fetchBackground:
    //     LocalNotification.initializer();
    //     LocalNotification.showOneTimeNotification(DateTime.now());
    //     //  15분마다 돌아가는 함수
    //     controller.checkLocation();
    //     break;
    //   default:
    // }

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
  // WidgetsFlutterBinding.ensureInitialized();
  //  geolocation initializing

  // print("latitude: " + controller.latitudeData.toString());
  // print("longitude: " + controller.longitudeData.toString());

  // await Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  // await Workmanager.registerPeriodicTask(
  //   "1",
  //   "GeolocationTask",
  //   // inputData: {"data1": "value1", "data2": "value2"},
  //   frequency: Duration(minutes: 1),
  //   initialDelay: Duration(minutes: 1),
  // );
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
