import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/model/http/ModelGetAccTimeRanker.dart';
import 'package:stay__home/model/http/ModelGetTopTimeRanker.dart';
import 'package:stay__home/service/httpHelper.dart';

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List<Datum> rankingAccData;
  List<Datun> rankingTopData;
  String buttonText;
  bool buttonState;
  int itemLength;

  @override
  void initState() {
    super.initState();

    buttonText = "누적시간별 랭킹";
    buttonState = true;
    itemLength = 0;

    Future.delayed(Duration.zero, () async {
      loadAccRankingList();
      loadTopRankingList();
    });
  }

  void loadAccRankingList() {
    HttpService().getAccTimeRanker().then((value) {
      setState(() {
        rankingAccData = value.data;
        itemLength = value.data.length;
      });
    });
  }

  void loadTopRankingList() {
    HttpService().getTopTimeRanker().then((value) {
      setState(() {
        rankingTopData = value.data;
        itemLength = value.data.length;
      });
    });
  }

  String valueToTimeString({@required int value}) {
    double second = value.toDouble();
    double minute = second / 60;
    double hour = minute / 60;
    double day = hour / 24;

    hour %= 24;
    minute %= 60;
    second %= 60;

    return day.toInt() > 0
        ? "${day.toInt()}일 ${hour.toInt()}시간 ${minute.toInt()}분 ${second.toInt()}초"
        : hour.toInt() > 0
            ? "${hour.toInt()}시간 ${minute.toInt()}분 ${second.toInt()}초"
            : minute.toInt() > 0
                ? "${minute.toInt()}분 ${second.toInt()}초"
                : "${second.toInt()}초";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSet().pointColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "랭킹",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CupertinoButton(
              child: Text(
                buttonText.toString(),
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (buttonState) {
                  setState(() {
                    buttonText = "최고시간 랭킹";
                    loadTopRankingList();
                    buttonState = !buttonState;
                  });
                } else {
                  setState(() {
                    buttonText = "누적시간별 랭킹";
                    loadAccRankingList();

                    buttonState = !buttonState;
                  });
                }
              })
        ],
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              buttonState
                  ? rankingAccData[index].name
                  : rankingTopData[index].name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              maxLines: 1,
            ),
            subtitle: Text(
              buttonState
                  ? valueToTimeString(value: rankingAccData[index].accTime)
                  : valueToTimeString(value: rankingTopData[index].topTime)
                ..toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            leading: Text(
              (index + 1).toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.shield,
              color: index == 0
                  ? Color(0xFFD4AF37)
                  : index == 1
                      ? Color(0xFFC0C0C0)
                      : index == 2
                          ? Color(0xFF9F7A34)
                          : Colors.transparent,
            ),
          );
        },
        itemCount:
            (rankingAccData == null && rankingTopData == null) ? 0 : itemLength,
      ),
    );
  }
}
