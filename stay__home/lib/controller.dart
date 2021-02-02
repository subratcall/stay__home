import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  static Controller get to => Get.find();

  Position position;

  //  위도: latitude, 경도: longitude
  double homeLatitude = 0;
  double homeLongitude = 0;

  String latitudeDataString = "";
  String longitudeDataString = "";

  double latitudeData = 0;
  double longitudeData = 0;

  getCurrentLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitudeDataString = '${geoPosition.latitude}';
    longitudeDataString = '${geoPosition.longitude}';
    latitudeData = geoPosition.latitude;
    longitudeData = geoPosition.longitude;
    update();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    update();
    return await Geolocator.getCurrentPosition();
  }

  checkLocation() {
    getCurrentLocation();
    //  집이 아닌 경우
    if (latitudeData > homeLatitude + 0.00100 ||
        latitudeData < homeLatitude - 0.00100 ||
        longitudeData > longitudeData + 0.00100 ||
        longitudeData < longitudeData - 0.00100) {
      print(latitudeData.toString() +
          ":" +
          longitudeData.toString() +
          "은 집이 아닙니다.");
    } else {
      print(
          latitudeData.toString() + ":" + longitudeData.toString() + "은 집입니다.");
    }
    update();
  }

  checkLocationParams(double _latitudeData, double _longitudeData) {
    getCurrentLocation();
    //  집이 아닌 경우
    if (_latitudeData > homeLatitude + 0.00100 ||
        _latitudeData < homeLatitude - 0.00100 ||
        _longitudeData > homeLongitude + 0.00100 ||
        _longitudeData < homeLongitude - 0.00100) {
      print(_latitudeData.toString() +
          ":" +
          _longitudeData.toString() +
          "은 집이 아닙니다.");
    } else {
      print(_latitudeData.toString() +
          ":" +
          _longitudeData.toString() +
          "은 집입니다.");
    }
    print("현재 집 = ${homeLatitude}:${homeLongitude}");
    update();
  }

  setHome() {
    getCurrentLocation();
    homeLatitude = latitudeData;
    homeLongitude = longitudeData;
    update();
  }
}
