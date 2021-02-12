import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TimeController extends GetxController {
  static TimeController get to => Get.find();

  bool timerState = true;
  AnimationController timercontroller;

  startTimer() {
    timercontroller.forward();
  }

  endTimer() {
    timercontroller.stop();
  }
}
