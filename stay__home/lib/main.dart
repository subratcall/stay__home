import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/view/mainPage.dart';
import 'package:stay__home/view/onboardingPage1.dart';
import 'package:stay__home/view/onboardingPage2.dart';
import 'package:stay__home/view/testPage.dart';
import 'package:workmanager/workmanager.dart';

const fetchBackground = "fetchBackground";
var locationcontroller = Get.put(LoactionController());

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print("${DateTime.now()} : Workmanager Start ! ");
        locationcontroller.checkLocationParams(
            userLocation.latitude, userLocation.longitude);
        break;
      default:
        locationcontroller.determinePosition();
        break;
    }
    return Future.value(true);
  });
}

void main() async {
  /*
   * Flutter WorkManager 초기 세팅
   * .initialize : callbackDispatcher 입력
   * .registerPeriodicTack : Task에 등록
  */
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager.registerPeriodicTask("1", fetchBackground,
      frequency: Duration(minutes: 15), initialDelay: Duration(minutes: 1));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: '/onboardingPage1',
      initialRoute: '/testPage',
      getPages: [
        GetPage(
          name: '/',
          page: () => MainPage(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/onboardingPage1',
          page: () => OnboardingPage1(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/onboardingPage2',
          page: () => OnboardingPage2(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/testPage',
          page: () => TestPage(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
