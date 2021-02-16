import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/service/httpHelper.dart';

class StartPage extends StatefulWidget {
  @override
  _StarPageState createState() => _StarPageState();
}

class _StarPageState extends State<StartPage> {
  Future<bool> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    if (firstTime != null && !firstTime) {
      // Not first time
      return false;
    } else {
      // First time
      return true;
    }
  }

  final httpService = new HttpService();

  @override
  Widget build(BuildContext context) {
    //   SharedPreferences를 통해 첫 실행인지 비교
    checkFirstTime().then((value) {
      if (!value) {
        //  첫 실행이 아니면 메인페이지로
        Get.offAllNamed('/');
      }
    });

    //  첫 실행이면 온보딩 실행
    return Scaffold(
      body: Center(
        child: renderFirstPage(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 55,
          color: ColorSet().pointColor,
          child: CupertinoButton(
            onPressed: () {
              Get.toNamed('/onboardingPage');
            },
            child: Text(
              "확인",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget renderFirstPage() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          renderTitle("챌린지 시작하기"),
          renderBody("간단한 등록으로 스테이 홈 챌린지를 시작하세요."),
        ],
      ),
    );
  }

  Widget renderSecondPage() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }

  Widget renderTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: Get.size.width,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
      ),
    );
  }

  Widget renderBody(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: Get.size.width,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
