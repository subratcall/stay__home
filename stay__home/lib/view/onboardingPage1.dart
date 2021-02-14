import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stay__home/service/httpHelper.dart';


class OnboardingPage1 extends StatefulWidget {
  @override
  _OnboardingPageState1 createState() => _OnboardingPageState1();
}

class _OnboardingPageState1 extends State<OnboardingPage1> {
  //   SQLite를 까서 봤을 때 계정이 없으면 첫실행으로 간주, 계정이 있으면 첫실행이 아닌걸로 간주
  final httpService = new HttpService();

  @override
  Widget build(BuildContext context) {
    // httpService.getUserInfo();
    // httpService.duplicateInspection("");
    httpService.createAccount(name: "이영범범", longitude: 0.0, latitude: 0.0);
    return Scaffold(
      body: Center(
        child: renderFirstPage(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 55,
          color: Colors.cyan,
          child: CupertinoButton(
            onPressed: () {
              Get.toNamed('/onboardingPage2');
            },
            child: Text(
              "확인",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,),
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
