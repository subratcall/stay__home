import 'package:flutter/material.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/view/mainPage.dart';
import 'package:stay__home/service/httpHelper.dart';
// import 'package:screenshot_share/screenshot_share.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';

class SectionDrawer extends StatefulWidget {
  @override
  _SectionDrawerState createState() => _SectionDrawerState();
}

class _SectionDrawerState extends State<SectionDrawer> {
  String nickname;
  final dbController = DBController();

  @override
  void initState() {
    dbController.onInit();
    super.initState();
  }

  getUserName() {
    dbController.user().then((value) {
      return value[0].name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getUserName(),
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: Text('집 설정'),
            onTap: () {
              //  유저 현재 위도 경도를 받아서
              //  서버 업데이트
              //  DB 업데이트
              print("집 설정");
            },
          ),
          ListTile(
            title: Text('공유하기'),
            onTap: () {
              print("공유하기");
            },
          ),
          ListTile(
            title: Text('문의하기'),
            onTap: () {
              NAlertDialog(
                title: Text("Test"),
                content: Text("개발자 이메일: fnvl7426@naver.com"),
                blur: 2,
              ).show(context);
              print("문의하기");
            },
          ),
        ],
      ),
    );
  }
}
