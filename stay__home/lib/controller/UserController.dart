import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  String name;
  double latitude;
  double longitude;
  int accTime;
  int topTime;

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

  void setAcctime(int acctime) {
    this.accTime = accTime;
    update();
  }

  void setTopTime(int topTime) {
    this.topTime = topTime;
    update();
  }

  String getName() => name != null ? name : "";
  double getLatitude() => latitude != null ? latitude : 0;
  double getLongitude() => longitude != null ? longitude : 0;
  int getAccTime() => accTime != null ? accTime : 0;
  int getTopTime() => topTime != null ? topTime : 0;
}
