import 'package:flutter/material.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/view/mainPage.dart';
import 'package:stay__home/service/httpHelper.dart';
import 'package:stay__home/view/rankingPage.dart';
// import 'package:screenshot_share/screenshot_share.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';

class SectionDrawer extends StatefulWidget {
  @override
  _SectionDrawerState createState() => _SectionDrawerState();
}

class _SectionDrawerState extends State<SectionDrawer> {
  String nickname = '닉네임설정';
  final controller = Get.put(LocationController());

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
                      nickname,
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {
                        controller.setHome();
                        print("닉네임 변경");
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: ListTile(
              // leading: Icon(Icons.location_on_outlined),
              title: Text('집 설정'),
              onTap: () {
                print("집 설정");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: ListTile(
              // leading: Icon(
              //   Icons.ios_share,
              //   color: Colors.black54,
              // ),
              title: Text('나의 랭킹 보기'),
              onTap: () {
                Get.to(RankingPage());
                print("랭킹보기");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: ListTile(
              // leading: Icon(
              //   Icons.mail_outline,
              //   color: Colors.black54,
              // ),
              title: Text('문의하기'),
              onTap: () {
                NAlertDialog(
                  title: Text("Test"),
                  content: Text("개발자 이메일: yblee@naver.com"),
                  blur: 2,
                ).show(context);
                print("문의하기");
              },
            ),
          ),
        ],
      ),
    );
  }
}
