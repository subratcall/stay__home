import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/service/httpHelper.dart';

class SectionBoard extends StatelessWidget {
  SectionBoard({this.title});

  final String title;
  final List<String> mainTextList = [
    '친구를',
    '가족을',
    '연인을',
    '뽀삐를',
    '세계평화를',
    '우주를',
    '해외여행을'
  ];
  final dbController = DBController();
  final locationController = Get.put(LocationController());

  DateTime startTime;
  DateTime endTime;
  var randomItem;

  @override
  Widget build(BuildContext context) {
    dbController.onInit();
    randomItem = (mainTextList..shuffle()).first;
    return Column(
      children: [
        Row(
          children: [
            // RaisedButton(
            //   child: Text("Test"),
            //   onPressed: () async {
            //     // await dbController.user().then((usr) {
            //     //   HttpService().getUserInfo(name: usr[0].name).then((value) {
            //     //     // print();
            //     //     var displayAccTime = value.data.accTime;
            //     //   });
            //     // });
            //   },
            // ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$randomItem",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              " 위해 집에 있어주세요",
              style: TextStyle(fontSize: 25, color: Colors.white),
            ),
          ],
        ),
        SizedBox(
          height: 100,
        ),
        Container(
          height: Get.size.height * 0.15,
          width: Get.size.width * 0.5,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              "🏡 Stay Home Challenge",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
