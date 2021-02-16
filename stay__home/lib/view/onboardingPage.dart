import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:stay__home/view/inputPage.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => OnboardingPage2()),
    );
  }

  // Widget _buildImage(String assetName) {
  //   return Align(
  //     child: Text('Image Section'),
  //     alignment: Alignment.bottomCenter,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
      titlePadding: EdgeInsets.fromLTRB(0, 80, 20, 20),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(10, 0.0, 10, 16.0),
      pageColor: Color(0xFFd9e1e8),
      imagePadding: EdgeInsets.zero,
    );

    const pageDecoration2 = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
      titlePadding: EdgeInsets.fromLTRB(0, 80, 160, 20),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(10, 0.0, 10, 16.0),
      pageColor: Color(0xFFd9e1e8),
      imagePadding: EdgeInsets.zero,
    );

    const pageDecoration3 = const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
      titlePadding: EdgeInsets.fromLTRB(0, 80, 70, 20),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(10, 0.0, 10, 16.0),
      pageColor: Color(0xFFd9e1e8),
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Stay Home Challenge는?",
          body:
              "Stay Home Challenge는 GPS 위치 기반으로 사용자가 집에 얼마나 있는지 체크하는 App이에요. 시간은 일:시간:초 로 나타나고 앱을 사용하지 않아도 위치를 확인하니 타이머가 정상적으로 작동하기 위해선 끄면 안 된답니다!",
          // image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "간단한 사용법!",
          body:
              "Stay Home Challenge는 처음 집설정만 해주고 끄지만 않는다면 알아서 시간을 측정해줍니다! 만약 집설정을 다시 하고 싶다면 메뉴에 들어가서 다시 집설정을 하면 돼요!",
          // image: _buildImage('img2'),
          decoration: pageDecoration2,
        ),
        PageViewModel(
          title: "자, 그럼 시작해볼까요?",
          body: "간단한 설정과 함께 바로 시작할 수 있어요!",
          // image: _buildImage('img3'),
          decoration: pageDecoration3,
        ),
        // PageViewModel(
        //   title: "Another title page",
        //   body: "Another beautiful body text for this example onboarding",
        //   // image: _buildImage('img2'),
        //   footer: RaisedButton(
        //     onPressed: () {
        //       introKey.currentState?.animateScroll(0);
        //     },
        //     child: const Text(
        //       'FooButton',
        //       style: TextStyle(color: Colors.white),
        //     ),
        //     color: Colors.lightBlue,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //   ),
        //   decoration: pageDecoration,
        // ),
        // PageViewModel(
        //   title: "Title of last page",
        //   bodyWidget: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: const [
        //       Text("Click on ", style: bodyStyle),
        //       Icon(Icons.edit),
        //       Text(" to edit a post", style: bodyStyle),
        //     ],
        //   ),
        //   // image: _buildImage('img1'),
        //   decoration: pageDecoration,
        // ),
        // PageViewModel(
        //     title: "Text('s중앙에서 어케 벗어나냐고 씨발~')",
        //     body: "어쩌라는거야",
        //     decoration: pageDecoration)
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        '건너뛰기',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Color(0xFF2b90d9),
      ),
      done: const Text('시작하기',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          )),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.white24,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}
