import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  String name;
  double latitude;
  double longitude;

  void setName(String name) {
    this.name = name;
    update();
  }

  void setLatitude(double latitude) {
    this.latitude = latitude;
    update();
  }

  void setLongitude(double longitude) {
    this.longitude = longitude;
    update();
  }

  String getName() => name;
  double getLatitude() => latitude;
  double getLongitude() => longitude;
}
