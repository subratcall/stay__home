import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/view/mainPage.dart';
import 'package:stay__home/service/httpHelper.dart';
import 'package:ndialog/ndialog.dart';
import 'package:get/get.dart';

class SectionDrawer extends StatefulWidget {
  @override
  _SectionDrawerState createState() => _SectionDrawerState();
}

class _SectionDrawerState extends State<SectionDrawer> {
  String nickName;
  String accTime = "로딩중";
  String topTime = "로딩중";

  String message = """
  안녕하세요? 😁

  StayHomeChallenge🏡개발팀입니다.
  버그 및 개선사항, 기타 문의내용이 있으시다면
  아래의 이메일 주소로 연락주시기 바랍니다.

  오창석 fnvl7426@naver.com
  이은재 eunzaeree@kakao.com
  이영범 deb_beom@kakao.com
  """;

  final locationController = Get.put(LocationController());
  final userController = Get.put(UserController());
  final colorSet = ColorSet();
  final dbController = DBController();

  @override
  void initState() {
    super.initState();
    nickName = userController.getName();
    locationController.determinePosition();
    dbController.onInit();

    Future.delayed(Duration.zero, () async {
      loadUserInfoToServer();
    });
  }

  void loadUserInfoToServer() {
    HttpService().getUserInfo(name: nickName).then((value) {
      setState(() {
        accTime = valueToTimeString(value: value.data.accTime);
        topTime = valueToTimeString(value: value.data.topTime);
      });
    });
  }

  String valueToTimeString({@required int value}) {
    double second = value.toDouble();
    double minute = second / 60;
    double hour = minute / 60;
    double day = hour / 24;

    hour %= 24;
    minute %= 60;
    second %= 60;

    return day.toInt() > 0
        ? "${day.toInt()}:${hour.toInt()}:${minute.toInt()}:${second.toInt()}"
        : hour.toInt() > 0
            ? "${hour.toInt()}:${minute.toInt()}:${second.toInt()}"
            : minute.toInt() > 0
                ? "${minute.toInt()}:${second.toInt()}"
                : "${second.toInt()}";
  }

  Widget renderListTileTitleText({@required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget renderListTileText({@required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget renderListTileWidgetRanking() {
    return ListTile(
      title: renderListTileText(text: "실시간 랭킹"),
      onTap: () {
        Get.toNamed('/rankingPage');
      },
      trailing: Icon(Icons.chevron_right_rounded),
    );
  }

  Widget renderListTileWidgetHomeAddressUpdate() {
    return ListTile(
      title: renderListTileText(text: "집주소 재설정"),
      onTap: () async {
        //  현재 위치로 집을 설정되었습니다.-> 메세지
        //  유저 현재 위도 경도를 받아서
        //  서버 업데이트
        //  DB 업데이트
        Get.snackbar(
          "알림",
          "집 주소가 현재 위치로 설정되었습니다.",
          colorText: ColorSet().lightColor,
          backgroundColor: ColorSet().pointColor,
        );
        Position userLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        await locationController.setHome();
        dbController.user().then((localUser) {
          HttpService().updateHomeAddress(
            name: localUser[0].name,
            latitude: userLocation.latitude,
            longitude: userLocation.longitude,
          );
          HttpService().getUserInfo(name: localUser[0].name).then((serverUser) {
            dbController
                .updateUser(User(
              id: 0,
              name: serverUser.data.name,
              accTime: serverUser.data.accTime,
              topTime: serverUser.data.topTime,
              latitude: serverUser.data.latitude,
              longitude: serverUser.data.longitude,
            ))
                .then((_) async {
              print("업뎃 완료");
              print(await dbController.user());
            });
          });
        });
      },
      trailing: Icon(Icons.chevron_right_rounded),
    );
  }

  Widget renderListTileWidgetReport() {
    return ListTile(
      title: renderListTileText(text: "문의하기"),
      onTap: () {
        NAlertDialog(
          title: Text(
            "문의하기 🏘",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(message),
          blur: 1,
        ).show(context);
        print("문의하기");
      },
      trailing: Icon(Icons.chevron_right_rounded),
    );
  }

  Widget renderRecordArea({@required int index}) {
    //  index == 0 => return accTime Box
    //  index == 1 => return topTime Box
    if (index != 0 && index != 1) {
      return null;
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              index == 0 ? "누적기록 " : "최고기록 ",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
            Text(
              index == 0 ? accTime.toString() : topTime.toString(),
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: AutoSizeText(
                    nickName + "님",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    renderRecordArea(index: 0),
                    renderRecordArea(index: 1),
                  ],
                ),
              ],
            ),
          ),
          renderListTileWidgetRanking(),
          Divider(
            height: 10,
          ),
          renderListTileTitleText(text: "설정"),
          renderListTileWidgetHomeAddressUpdate(),
          renderListTileWidgetReport(),
          Divider(),
        ],
      ),
    );
  }
}
