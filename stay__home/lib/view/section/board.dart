import 'package:flutter/material.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/dbController.dart';

class SectionBoard extends StatelessWidget {
  SectionBoard({this.title});

  final String title;
  final List<String> mainTextList = ['친구', '가족', '연인'];
  final dbController = DBController();

  var user = User(
    id: 0,
    name: "홈밍이",
    topTime: 0,
    accTime: 0,
    latitude: 0,
    longitude: 0,
  );

  @override
  Widget build(BuildContext context) {
    mainTextList.sort();
    dbController.onInit();
    return Column(
      children: [
        Row(
          children: [
            RaisedButton(
              onPressed: () async {
                // await dbController.insertUser(user);
                print(await dbController.user());
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
