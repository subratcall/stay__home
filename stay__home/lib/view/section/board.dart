import 'package:flutter/material.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

class SectionBoard extends StatelessWidget {
  SectionBoard({this.title});

  final String title;
  final List<String> mainTextList = [
    '친구를',
    '가족을',
    '연인을',
    '초코를',
    '감자를',
    '곧 생길 연인을...ㅠ',
    '고양이를',
    '강아지를',
    '코로나 방역을',
    '부자가 되기',
    '주식 떡상을'
  ];
  final dbController = DBController();

  @override
  Widget build(BuildContext context) {
    dbController.onInit();
    return Column(
      children: [
        // Row(
        //   children: [
        //     RaisedButton(
        //       onPressed: () async {
        //         // await dbController.insertUser(user);
        //         print(await dbController.user());
        //       },
        //     ),
        //   ],
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: Get.size.height * 0.05,
              child: AutoSizeText(
                "${mainTextList[Random().nextInt(10)]} 위해 집에 있어 주세요",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                maxLines: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 40),
        Container(
          height: Get.size.height * 0.08,
          child: AutoSizeText(
            "# Stay Home Challenge",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
