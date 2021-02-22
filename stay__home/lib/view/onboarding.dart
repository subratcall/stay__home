import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 100.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 17.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.transparent,
      imagePadding: EdgeInsets.all(25),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Stay Home Challenge ?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "GPS 좌표를 기반으로\n사용자가 집에 얼마나 있는지 체크해줍니다.",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          bodyWidget: Container(),
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "사용방법",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "집 위치를 알려주면 알아서 척척.\n집 주소를 변경할 수도 있어요.",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          bodyWidget: Container(),
          image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "시작",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "간단한 설정과 함께\n바로 시작할 수 있어요.",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
          bodyWidget: Container(),
          image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => Get.toNamed('/inputPage'),
      onSkip: () => Get.toNamed('/inputPage'),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('건너뛰기', style: TextStyle(fontWeight: FontWeight.bold)),
      next: const Text('다음', style: TextStyle(fontWeight: FontWeight.bold)),
      done: const Text('시작하기', style: TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        activeColor: Color(0xFF2b90d9),
        color: Color(0xFF9baec8),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
