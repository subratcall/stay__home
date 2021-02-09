import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/view/myHomePage.dart';
import 'package:workmanager/workmanager.dart';

//   의존성 추가
import 'package:path/path.dart'; //  디스크에 저장할 데이터베이스의 위치를 정확히 정의할 수 있는 함수를 제공해주는 라이브러리.
import 'package:sqflite/sqflite.dart'; //  SQLite 데이터베이스를 사용할 수 있도록 여러 클래스와 함수를 제공해주는 라이브러리.

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
   * .registerPeriodicTack : Tack에 등록
  */
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  Workmanager.registerPeriodicTask("1", fetchBackground,
      frequency: Duration(minutes: 15), initialDelay: Duration(minutes: 1));

  /*
   * SQLite 데이터베이스 설정
   */
  final database = openDatabase(
    //  데이터베이스 경로를 지정한다.
    //  참고: 'path' 패키지의 'join'함수를 사용하는 것이
    //  각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법이다.
    join(await getDatabasesPath(), 'stayHome_database.db'),
    //  데이터베이스가 처음 생성될 때, 정보를 저장하기 위한 테이블을 생성한다.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE user(id INTEGER PRIMARY KEY,name TEXT, topTime INTEGER, accTime INTEGER, latitude REAL, longitude REAl)",
      );
    },
    version: 1,
  );

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
