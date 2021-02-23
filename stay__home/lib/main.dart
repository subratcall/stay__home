import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/service/httpHelper.dart';
import 'package:stay__home/view/mainPage.dart';
import 'package:stay__home/view/inputPage.dart';
import 'package:stay__home/view/onboarding.dart';
import 'package:stay__home/view/rankingPage.dart';
import 'package:stay__home/view/startPage.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const fetchBackground = "fetchBackground";
final locationController = Get.put(LocationController());
final userController = Get.put(UserController());
final dbController = DBController();

//  Workmanager Task
void callbackDispatcher() {
  try {
    Workmanager.executeTask((task, inputData) async {
      switch (task) {
        case fetchBackground:
          try {
            dbController.onInit();

            SharedPreferences prefs = await SharedPreferences.getInstance();
            String startTimePrefs = prefs.getString('start_time');
            DateTime getStartTimePrefsDateTime;
            DateTime dateTimeNTPNow = await NTP.now();
            double sendSecond;
            Position userLocation = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            await dbController.user().then((value) {
              //  SQlite의 User Data의 집주소와 현재 위치를 비교
              //  집이 아닌 경우
              if (userLocation.latitude > value[0].latitude + 0.00100 ||
                  userLocation.latitude < value[0].latitude - 0.00100 ||
                  userLocation.longitude > value[0].longitude + 0.00100 ||
                  userLocation.longitude < value[0].longitude - 0.00100) {
                //  시작 시간이 비어있지 않으면, 타이머가 작동하고 있다는 의미
                if (startTimePrefs != "") {
                  //  getStartTimePrefsDataTime에 Prefs의 start_time값을 파싱해 DateTime 형식으로 바꿈

                  getStartTimePrefsDateTime =
                      new DateFormat("yyyy-MM-dd hh:mm:ss")
                          .parse(prefs.getString("start_time"));

                  //  서버에 보낼 시간을 계산함.
                  sendSecond = dateTimeNTPNow
                      .difference(getStartTimePrefsDateTime)
                      .inSeconds
                      .toDouble();

                  //  SQlite의 User Data를 기반으로 서버에 시간을 전송후 SQlite의 재저장
                  dbController.user().then((localUser) {
                    HttpService()
                        .updateTime(name: localUser[0].name, time: sendSecond);
                    HttpService()
                        .getUserInfo(name: localUser[0].name)
                        .then((serverUser) {
                      dbController
                          .updateUser(User(
                        id: 0,
                        name: serverUser.data.name,
                        accTime: serverUser.data.accTime,
                        topTime: serverUser.data.topTime,
                        latitude: serverUser.data.latitude,
                        longitude: serverUser.data.longitude,
                      ))
                          .then((_) async {
                        print("업뎃 완료");
                        print(await dbController.user());
                      });
                    });
                  });
                  prefs.setString('start_time', "");
                }
                prefs.setString('start_time', "");
                print("집이 아닙니다.");
              } else {
                //  집인 경우
                if (startTimePrefs == "") {
                  prefs.setString('start_time', dateTimeNTPNow.toString());
                }
                print("집입니다.");
              }
            });
          } catch (e) {
            Get.snackbar("오류", "오류메세지 $e",
                colorText: ColorSet().lightColor,
                backgroundColor: ColorSet().pointColor);
          }
          break;
        default:
          locationController.determinePosition();
          break;
      }
      return Future.value(true);
    });
  } catch (e) {
    print("Error: " + e);
  }
}

//   SharedPreferences를 통해 첫 실행인지 비교
//  첫 실행이면 온보딩 실행
Future<bool> checkFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstTime = prefs.getBool('first_time');
  if (firstTime != null && !firstTime) {
    // Not first time
    return false;
  } else {
    // First time
    return true;
  }
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
  checkFirstTime().then((value) {
    if (value) {
      //  첫 실행이면
      runApp(MyApp(
        route: '/startPage',
      ));
    } else {
      //  첫 실행이 아니면
      runApp(MyApp(
        route: '/',
      ));
    }
  });
}

class MyApp extends StatelessWidget {
  final locationController = Get.put(LocationController());
  final String route;

  MyApp({@required this.route});

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
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              primarySwatch: Colors.grey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: this.route,
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
                name: '/inputPage',
                page: () => InputPage(),
                transition: Transition.fadeIn,
              ),
              GetPage(
                  name: '/onboardingPage',
                  page: () => OnBoardingPage(),
                  transition: Transition.fadeIn),
              GetPage(
                name: '/rankingPage',
                page: () => RankingPage(),
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
