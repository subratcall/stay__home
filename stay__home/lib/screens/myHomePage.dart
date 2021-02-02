import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller.dart';
import 'package:stay__home/screens/section/board.dart';
import 'package:stay__home/screens/section/drawer.dart';
import 'package:stay__home/screens/section/timer.dart';
import 'package:stay__home/util/http.dart';
import 'package:workmanager/workmanager.dart';

import '../main.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = Get.put(Controller());
  String showText;
  Position position;

  String latitudeData = "";
  String longitudeData = "";

  DateTime startTime;
  DateTime endTime;
  int resultTime;

  DateTime virtualTime;

  @override
  void initState() {
    super.initState();
    controller.determinePosition();
    controller.getCurrentLocation();
    Workmanager.initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    Workmanager.registerPeriodicTask("1", fetchBackground,
        frequency: Duration(minutes: 15), initialDelay: Duration(seconds: 1));
  }

  startTimer() {
    startTime = DateTime.now();

    print("Start Time: " + startTime.toString());
  }

  endTimer() {
    endTime = DateTime.now();
    resultTime = (-(startTime.difference(endTime)).inSeconds);
    print("End Time: " + endTime.toString());
    print("Result Second: " + resultTime.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      drawer: SectionDrawer(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // _buildLocateButton(),
                SectionBoard(),
                SectionTimer(),
                // _builcAddButton(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      onPressed: () {
                        startTimer();
                      },
                      child: Text("시작"),
                    ),
                    OutlineButton(
                      onPressed: () {
                        endTimer();
                      },
                      child: Text("종료"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                      onPressed: () {
                        controller.setHome();
                      },
                      child: Text("집 설정"),
                    ),
                    OutlineButton(
                      onPressed: () {
                        controller.checkLocation();
                      },
                      child: Text("체크"),
                    ),
                    OutlineButton(
                      onPressed: () {
                        Https()
                            .getHttp("http://15.164.195.117:3000/api/utils/");
                      },
                      child: Text("Http 통신"),
                    ),
                  ],
                ),
                GetBuilder<Controller>(builder: (_) {
                  return Column(
                    children: [
                      Text(_.homeLatitude.toString()),
                      Text(_.homeLongitude.toString()),
                    ],
                  );
                }),

                // _buildAddButtonGradient(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
