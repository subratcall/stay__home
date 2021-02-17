import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RankingPage extends StatefulWidget {
  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  List rankingData;
  String url = "15.24"; // 여기에 넣어줘야 함

  Future<String> getData() async {
    http.Response response = await http.get(url);

    this.setState(() {
      rankingData = jsonDecode(response.body);
    });

    return "Bringing RankingData Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(rankingData[index]["rankingData"]), // 이 부분 수정 필요!
          leading: Text(index.toString()),
        );
      },
      itemCount: rankingData == null ? 0 : rankingData.length,
    )
        // body: Container(
        //   child: Center(
        //     child: Text(
        //       'Ranking Page',
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 18,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
