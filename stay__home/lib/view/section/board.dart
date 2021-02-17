import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/service/httpHelper.dart';

class SectionBoard extends StatelessWidget {
  SectionBoard({this.title});

  final String title;
  final List<String> mainTextList = ['친구', '가족', '연인'];
  final dbController = DBController();
  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    dbController.onInit();
    return Column(
      children: [
        Row(
          children: [
            RaisedButton(
              onPressed: () async {
                HttpService().getUserInfo(name: "이영범범").then((value) {
                  print(value.data.name);
                });
                // HttpService().getUserInfo2(name: "이영범범");
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Text("🏡 Stay Home Challenge"),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${mainTextList[0]}",
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
}
