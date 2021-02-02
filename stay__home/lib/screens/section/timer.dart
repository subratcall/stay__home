import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class SectionTimer extends StatefulWidget {
  @override
  _SectionTimerState createState() => _SectionTimerState();
}

class _SectionTimerState extends State<SectionTimer> {
  int _duration = 10;
  CountDownController _timercontroller = CountDownController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Center(
            child: CircularCountDownTimer(
              duration: _duration,

              // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
              controller: _timercontroller,

              // Width of the Countdown Widget.
              width: MediaQuery.of(context).size.width / 2,

              // Height of the Countdown Widget.
              height: MediaQuery.of(context).size.height / 2.5,

              // Ring Color for Countdown Widget.
              color: Colors.grey[100],

              // 이 부분이 keycolor로 들어가면 될 듯?
              fillColor: Colors.purpleAccent[100],

              // Background Color for Countdown Widget.
              backgroundColor: Colors.white,

              // Border Thickness of the Countdown Ring.
              strokeWidth: 15.0,

              // Begin and end contours with a flat edge and no extension.
              strokeCap: StrokeCap.round,

              // Text Style for Countdown Text.
              textStyle: TextStyle(
                  fontSize: 33.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),

              // Format for the Countdown Text.
              textFormat: CountdownTextFormat.HH_MM_SS,

              // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
              isReverse: false,

              // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
              isReverseAnimation: false,

              // Handles visibility of the Countdown Text.
              isTimerTextShown: true,

              // Handles the timer start.
              autoStart: false,

              // This Callback will execute when the Countdown Starts.
              onStart: () {
                // Here, do whatever you want
                print('Countdown Started');
              },

              // This Callback will execute when the Countdown Ends.
              onComplete: () {
                // Here, do whatever you want
                print('Countdown Ended');
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                  onPressed: () {
                    _timercontroller.start();
                  },
                  child: Text("T 시작")),
              FlatButton(
                  onPressed: () {
                    _timercontroller.pause();
                  },
                  child: Text("T 종료")),
            ],
          )
        ],
      ),
    );
  }
}
