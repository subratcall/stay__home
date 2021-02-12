import 'package:flutter/material.dart';
import 'package:stay__home/controller/TimeController.dart';
import 'package:get/get.dart';

class SectionTimer extends StatefulWidget {
  @override
  _SectionTimerState createState() => _SectionTimerState();
}

class _SectionTimerState extends State<SectionTimer>
    with TickerProviderStateMixin {
  final timerController = Get.put(TimeController());
  int levelClock = 1800000;

  @override
  void dispose() {
    TimeController().dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    timerController.timercontroller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    // _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimeController>(builder: (_) {
      return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Countdown(
            animation: StepTween(
              begin: 0, // THIS IS A USER ENTERED NUMBER
              end: levelClock,
            ).animate(timerController.timercontroller),
          ),
          Row(
            children: [
              RaisedButton(onPressed: () => timerController.startTimer()),
              RaisedButton(onPressed: () => timerController.endTimer()),
            ],
          ),
        ],
      ),
    );
  });
}

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${(clockTimer.inDays).toString()}D:${(clockTimer.inHours.remainder(24)).toString().padLeft(2, '0')}H:${(clockTimer.inMinutes.remainder(60)).toString().padLeft(2, '0')}M';

    print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 50,
        color: Colors.black,
      ),
    );
  }
}
