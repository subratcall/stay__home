import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/view/mainPage.dart';
import 'package:stay__home/view/inputPage.dart';
import 'package:stay__home/view/onboarding.dart';
import 'package:stay__home/view/startPage.dart';
import 'package:stay__home/view/testPage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const fetchBackground = "fetchBackground";
final locationController = Get.put(LocationController());
final dbController = DBController();

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    switch (task) {
      case fetchBackground:
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print("${DateTime.now()} : Workmanager Start ! ");
        locationController.checkLocationParams(
            userLocation.latitude, userLocation.longitude);
        break;
      default:
        locationController.determinePosition();
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
  dbController.onInit();
  // print(await dbController.user());
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    locationController.determinePosition();
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Splash(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.grey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: '/startPage',
            getPages: [
              GetPage(
                name: '/',
                page: () => MainPage(),
                transition: Transition.fadeIn,
              ),
              GetPage(
                name: '/startPage',
                page: () => StartPage(),
                transition: Transition.fadeIn,
              ),
              GetPage(
                  name: '/onboardingPage',
                  page: () => OnBoardingPage(),
                  transition: Transition.fadeIn),
              GetPage(
                name: '/inputPage',
                page: () => InputPage(),
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
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet().pointColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.size.height * 0.15,
              ),
              Text(
                "#StayHome",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 55,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
