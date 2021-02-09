import 'package:flutter/material.dart';

class SectionBoard extends StatelessWidget {
  SectionBoard({this.title});

  final String title;
  final List<String> mainTextList = ['친구', '가족', '연인'];

  @override
  Widget build(BuildContext context) {
    mainTextList.sort();

    return Column(
      children: [
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
