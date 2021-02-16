import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  /*
   * GetBuilder 밖의 여러 곳에서 controller를 사용해야 하는 경우,
   * 간단하게 Controller 클래스 안의 getter로 접근할 수 있음.
   * 
   * 꼭 이렇게 할 필요는 없지만, 문법적으로 용이하게 사용하기 위해 권장.
   * static 메소드로 사용할 경우: Controller.to.conter();
   * static 메소드로 사용하지 않을 경우: Get.find<Controller>().counter();
   * 이 둘 간의 성능적 차이는 없으며, 문법적 차이로 오는 부ㅏㄱ용도 없다.
   * 단순히 하나는 type를 적을 필요가 없고, 다른 하나는 IDE가 자동완성 해준다는 차이점밖에 없음.
   */
  // static LocationController get to => Get.find();

  Position position;
  RxBool isHome = false.obs;

  double homeLatitude = 0; //  집의 위도
  double homeLongitude = 0; //  집의 경도

  String latitudeDataString = "";
  String longitudeDataString = "";

  double latitudeData = 0;
  double longitudeData = 0;

  double getHomeLatitude() => latitudeData;
  double getHomeLongitude() => longitudeData;

  String locationString = "";

  setLocationString(String locationString) {
    this.locationString = locationString;
    update();
  }

  getCurrentLocation() async {
    final geoPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    latitudeDataString = '${geoPosition.latitude}';
    longitudeDataString = '${geoPosition.longitude}';
    latitudeData = geoPosition.latitude;
    longitudeData = geoPosition.longitude;
    print(latitudeDataString + longitudeDataString);
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

  checkLocation() async {
    await getCurrentLocation();
    //  집이 아닌 경우
    if (latitudeData > homeLatitude + 0.00100 ||
        latitudeData < homeLatitude - 0.00100 ||
        longitudeData > longitudeData + 0.00100 ||
        longitudeData < longitudeData - 0.00100) {
      print(latitudeData.toString() +
          ":" +
          longitudeData.toString() +
          "은 집이 아닙니다.");
      isHome.value = false;
    } else {
      print(
          latitudeData.toString() + ":" + longitudeData.toString() + "은 집입니다.");
      isHome.value = true;
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
      isHome.value = false;
    } else {
      print(_latitudeData.toString() +
          ":" +
          _longitudeData.toString() +
          "은 집입니다.");
      isHome.value = true;
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
