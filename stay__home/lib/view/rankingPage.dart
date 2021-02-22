import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorSet().pointColor,
        automaticallyImplyLeading: false,
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
            ),
            leading: Text(
              (index + 1).toString(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              buttonState
                  ? rankingAccData[index].accTime.toString()
                  : rankingTopData[index].topTime.toString()
                ..toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
            ),
          );
        },
        itemCount:
            (rankingAccData == null && rankingTopData == null) ? 0 : itemLength,
      ),
    );
  }
}
