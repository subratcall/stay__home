import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stay__home/controller/TimeController.dart';

class SectionTimer extends StatefulWidget {
  @override
  _SectionTimerState createState() => _SectionTimerState();
}

class _SectionTimerState extends State<SectionTimer>
    with TickerProviderStateMixin {
  final _timeController = Get.put(TimeController());
  AnimationController _controller;
  int levelClock = 1800000;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    // _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Countdown(
            animation: StepTween(
              begin: 0, // THIS IS A USER ENTERED NUMBER
              end: levelClock,
            ).animate(_controller),
          ),
          Row(
            children: [
              // RaisedButton(onPressed: () => _controller.forward()),
              // RaisedButton(onPressed: () => _controller.stop()),
            ],
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${(clockTimer.inDays).toString()}:${(clockTimer.inHours.remainder(24)).toString().padLeft(2, '0')}:${(clockTimer.inMinutes.remainder(60)).toString().padLeft(2, '0')}';

    print('animation.value  ${animation.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    return Column(
      children: [
        Text(
          "$timerText",
          style: TextStyle(
            fontSize: 75,
            color: Colors.black,
          ),
        ),
        Text(
          clockTimer.inSeconds.remainder(60).toString() + ' s',
          style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.w300),
        )
      ],
    );
  }
}
