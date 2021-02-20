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
      child: Image.asset('assets/$assetName.png', width: 175.0),
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
      pageColor: Color(0xFFd9e1e8),
      imagePadding: EdgeInsets.all(25),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Stay Home Challenge란?",
          body:
              "Stay Home Challenge는 GPS 위치 기반으로 사용자가 집에 얼마나 있는지 체크하는 App이에요. 시간은 일:시간:초 로 나타나고 앱을 사용하지 않아도 위치를 확인하니 타이머가 정상적으로 작동하기 위해선 끄면 안 된답니다!",
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "어떻게 사용할까요?",
          body:
              "Stay Home Challenge는 처음 집설정만 해주고 끄지만 않는다면 알아서 시간을 측정해줍니다! 만약 집설정을 다시 하고 싶다면 메뉴에 들어가서 다시 집설정을 하면 돼요!",
          image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "그럼 시작해볼까요?",
          body: "간단한 설정과 함께 바로 시작할 수 있어요!",
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
      next: const Icon(Icons.arrow_forward),
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
