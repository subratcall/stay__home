import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller.dart';
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

  List<String> mainTextList = ['친구', '가족', '연인'];
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
    // mainTextList.sort();
    showText = mainTextList.elementAt(2);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xffFFFFFF), Color(0xffFFFFFF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // _buildLocateButton(),
                _buildText(),
                _buildTimer(),
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

  Widget _buildBottomSheet(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          // Center(
          //   child: Container(
          //     color: Colors.black,
          //     width: 100,
          //     height: 100,
          //   ),
          // ),
          ListTile(
            leading: Icon(CupertinoIcons.placemark_fill, color: Colors.green),
            title: Container(child: Text('집 위치 설정')),
            trailing: Text('집 위치(' + latitudeData + "," + longitudeData + ")"),
            onTap: () {
              controller.getCurrentLocation();
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.chart_bar_fill, color: Colors.green),
            title: Container(child: Text('랭킹 확인')),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(CupertinoIcons.share_solid, color: Colors.green),
            title: Container(child: Text('공유하기')),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(CupertinoIcons.info, color: Colors.green),
            title: Container(child: Text('문의하기')),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    return Column(
      children: [
        SizedBox(height: 100),
        Text("🏡 Stay Home Challenge"),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$showText",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "를 위해 집에 있어 주세요",
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ],
    );
  }

  Widget _builcAddButton() {
    return CupertinoButton(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildAddButtonGradient() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Container(
        height: 50.0,
        width: 50.0,
        child: RaisedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: _buildBottomSheet,
                isScrollControlled: false);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffdce35b), Color(0xff45b649)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Icon(
                CupertinoIcons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocateButton() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoButton(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.placemark,
                      color: Colors.white,
                    ),
                    Text(
                      "집 위치 설정",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "1",
              style: TextStyle(fontSize: 50),
            ),
            Text(
              "일",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "21",
              style: TextStyle(fontSize: 50),
            ),
            Text(
              "시간",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "52",
              style: TextStyle(fontSize: 50),
            ),
            Text(
              "분",
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
