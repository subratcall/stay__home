import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TimeController extends GetxController {
  static TimeController get to => Get.find();

  bool timerState = false;

  startTimer() {
    timerState = true;
    update();
  }

  endTimer() {
    timerState = false;
    update();
  }
}
