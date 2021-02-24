import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/main.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/view/section/board.dart';
import 'package:stay__home/view/section/drawer.dart';
import 'package:stay__home/view/section/timer.dart';

import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final locationcontroller = Get.put(LocationController());
  final dbController = Get.put(DBController());
  final userController = Get.put(UserController());

  //  앱 실행 시, userController에 db 내용을 저장
  @override
  void initState() {
    dbController.onInit();
    locationcontroller.determinePosition();
    locationcontroller.getCurrentLocation();
    Future.delayed(Duration.zero, () async {
      dbController.user().then((localUserDataBase) {
        userController.setName(localUserDataBase[0].name);
        userController.setAcctime(localUserDataBase[0].accTime);
        userController.setTopTime(localUserDataBase[0].topTime);
        userController.setLatitude(localUserDataBase[0].latitude);
        userController.setLongitude(localUserDataBase[0].longitude);
      });
    });

    super.initState();
  }

  void checkPermission() async {
    if (await permission_handler.Permission.location.isDenied) {
      await permission_handler.Permission.location.request();
    }
    if (await permission_handler.Permission.location.isPermanentlyDenied) {
      permission_handler.openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet().pointColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: SectionDrawer(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SectionTimer(),
                SizedBox(
                  height: 80,
                ),
                SectionBoard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
