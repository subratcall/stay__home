import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:isolate';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/main.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/service/httpHelper.dart';

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

  DateTime getStartTimePrefsDateTime;
  double sendSecond;
  double displaySecond;
  String startTimePrefs;

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
      sendPort.send(msg);
    });
  }

  void _handleMessage(dynamic data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    startTimePrefs = prefs.getString('start_time');
    Position userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
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

            getStartTimePrefsDateTime = DateFormat("yyyy-MM-dd hh:mm:ss")
                .parse(prefs.getString("start_time"));

            //  서버에 보낼 시간을 계산함.
            sendSecond = DateTime.now()
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
          isHome = false;
        } else {
          //  집인 경우
          if (startTimePrefs == "" || startTimePrefs == null) {
            prefs.setString('start_time', DateTime.now().toString());
          }

          // Display 용 계산
          getStartTimePrefsDateTime = DateFormat("yyyy-MM-dd hh:mm:ss")
              .parse(prefs.getString("start_time"));

          //  서버에 보낼 시간을 계산함.
          displaySecond = DateTime.now()
              .difference(getStartTimePrefsDateTime)
              .inSeconds
              .toDouble();
          print("집입니다.");
          isHome = true;
        }
      });
      if (isHome) {
        setState(() {
          noti = data;
          count = displaySecond;
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
          minute = 0;
          hour = 0;
          day = 0;
          count = 0;
        });
      }
    } catch (e) {
      Get.snackbar("오류", "오류메세지 $e",
          colorText: ColorSet().lightColor,
          backgroundColor: ColorSet().pointColor);
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

  void sendData(var data) {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0.0,
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: Get.size.width * 0.8,
                  height: Get.size.width * 0.3,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      day.toInt() > 0
                          ? "${day.toInt()}:${hour.toInt()}:${minute.toInt()}:${second.toInt()}"
                          : hour.toInt() > 0
                              ? "${hour.toInt()}:${minute.toInt()}:${second.toInt()}"
                              : minute.toInt() > 0
                                  ? "${minute.toInt()}:${second.toInt()}"
                                  : "${second.toInt()}",
                      style: TextStyle(
                          color: ColorSet().pointColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
