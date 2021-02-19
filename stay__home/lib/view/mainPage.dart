import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/main.dart';
import 'package:stay__home/view/section/board.dart';
import 'package:stay__home/view/section/drawer.dart';
import 'package:stay__home/view/section/timer.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final locationcontroller = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    locationcontroller.determinePosition();
    locationcontroller.getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorSet().pointColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: SectionDrawer(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SectionTimer(),
                SizedBox(
                  height: 80,
                ),
                SectionBoard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
