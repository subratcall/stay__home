import 'package:flutter/material.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/view/mainPage.dart';
import 'package:stay__home/service/httpHelper.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';

class SectionDrawer extends StatefulWidget {
  @override
  _SectionDrawerState createState() => _SectionDrawerState();
}

class _SectionDrawerState extends State<SectionDrawer> {
  String nickName;
  String accTime = "로딩중";
  String topTime = "로딩중";

  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    nickName = userController.getName();
    Future.delayed(Duration.zero, () async {
      loadUserInfoToServer();
    });
  }

  void loadUserInfoToServer() {
    HttpService().getUserInfo(name: nickName).then((value) {
      setState(() {
        accTime = value.data.accTime.toString();
        topTime = value.data.topTime.toString();
      });
    });
  }

  void renderRecordBox() {}

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
                    Container(
                      child: Text(
                        nickName + "님",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      height: 50,
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("누적 기록"),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: Colors.deepOrange,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          accTime.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      child: Text("최고 기록"),
                    ),
                    Container(
                      child: Text(
                        topTime.toString(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          ListTile(
            title: Text('집 설정'),
            onTap: () {
              //  현재 위치로 집을 설정되었습니다.-> 메세지
              //  유저 현재 위도 경도를 받아서
              //  서버 업데이트
              //  DB 업데이트
              print("집 설정");
            },
          ),
          ListTile(
            title: Text('랭킹페이지'),
            onTap: () {
              Get.toNamed('/rankingPage');
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
