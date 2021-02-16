import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stay__home/controller/LocationController.dart';
import 'package:stay__home/controller/UserController.dart';
import 'package:stay__home/design/ColorSet.dart';
import 'package:stay__home/model/uesr.dart';
import 'package:stay__home/service/databaseHelper.dart';
import 'package:stay__home/service/httpHelper.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  bool isNameOk;
  bool isLocationOk;

  String tileText;
  final _formKey = GlobalKey<FormState>();
  Position position;

  String latitudeData = "";
  String longitudeData = "";

  DateTime startTime;
  DateTime endTime;
  int resultTime;

  DateTime virtualTime;
  String translateAddress;

  final locationController = Get.put(LocationController());
  final userController = Get.put(UserController());

  final dbController = DBController();

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isNameOk = false;
    isLocationOk = false;

    translateAddress = "";

    locationController.determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    dbController.onInit();
    return Scaffold(
      body: Center(
        child: renderSecondPage(),
      ),
      bottomNavigationBar: GetBuilder<LocationController>(
        builder: (_) {
          if (_.longitudeData != 0.0 || _.latitudeData != 0.0) {
            isLocationOk = true;
          } else {
            isLocationOk = false;
          }
          return BottomAppBar(
            child: Container(
              height: 55,
              color: isNameOk && isLocationOk
                  ? ColorSet().pointColor
                  : ColorSet().mediumColor,
              child: CupertinoButton(
                disabledColor: ColorSet().mediumColor,
                onPressed: isNameOk && isLocationOk
                    ? () async {
                        await HttpService()
                            .createAccount(
                                name: userController.getName(),
                                latitude: locationController.getHomeLatitude(),
                                longitude:
                                    locationController.getHomeLongitude())
                            .then(
                          (value) async {
                            if (value) {
                              //  계정 생성 성공
                              var user = User(
                                id: 0,
                                name: userController.getName(),
                                topTime: 0,
                                accTime: 0,
                                latitude: locationController.getHomeLatitude(),
                                longitude:
                                    locationController.getHomeLongitude(),
                              );
                              await dbController.insertUser(user);

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('first_time', false);

                              Get.toNamed('/');
                            } else {
                              //  계정 생성 오류
                              Get.offAllNamed('startPage');
                            }
                          },
                        );
                      }
                    : null,
                child: Text(
                  "확인",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget renderSecondPage() {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderTitle("사용하실 닉네임을 입력해 주세요"),
            SizedBox(
              height: 20,
            ),
            renderNameForm(),
            SizedBox(
              height: 100,
            ),
            renderTitle("집의 위치를 설정해주세요"),
            SizedBox(
              height: 20,
            ),
            renderLocation(),
          ],
        ));
  }

  Widget renderLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: ColorSet().pointColor,
        ),
        child: ListTile(
          onTap: () async {
            await locationController.setHome();
            translateAddress = await HttpService().translateAddress(
                latitude: locationController.homeLatitude,
                longitude: locationController.homeLongitude);
            setState(() {
              isLocationOk = true;
            });
          },
          title: Text(
            "현재 위치를 집으로 설정합니다",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: GetBuilder<LocationController>(
            builder: (_) {
              if (_.longitudeData == 0.0 || _.latitudeData == 0.0) {
                tileText = "클릭으로 위치를 지정해 주세요.";
              } else {
                tileText = translateAddress == "" || null
                    ? "${_.longitudeData.toString()}, ${_.latitudeData.toString()}"
                    : translateAddress;
                //  translateAddress API 요청 오류나, 요청 초과가 이뤄진다면 생기는 에러에 대해 처리가 필요하다.
              }
              return Text(
                tileText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget renderTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: Get.size.width,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  Widget renderNameForm() {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: Get.size.width * 0.5,
              child: TextFormField(
                controller: _textEditingController,
                style: TextStyle(fontSize: 30),
                // 텍스트폼필드에 validator 추가
                validator: (value) {
                  // 입력값이 없으면 메시지 출력
                  if (value.isEmpty) {
                    return 'Enter some text';
                  } else
                    return null;
                },
                // 텍스트폼필드에 스타일 적용
                decoration: InputDecoration(
                    // 텍스트필드의 외각선
                    border: InputBorder.none,
                    // 텍스트필드상에 출력되는 텍스트. 실제 값이 되진 않음
                    hintText: "닉네임 입력",
                    // 텍스트필드의 상단에 출력되는 레이블 텍스트
                    labelText: null),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 100,
              height: 70,
              child: FlatButton(
                color: ColorSet().pointColor,
                onPressed: () {
                  // 텍스트폼필드의 상태가 적함하는
                  if (_formKey.currentState.validate()) {
                    HttpService()
                        .duplicateInspection(_textEditingController.text)
                        .then((value) {
                      if (value == true) {
                        Get.snackbar("알림", "사용 가능한 닉네임입니다.",
                            colorText: ColorSet().lightColor,
                            backgroundColor: ColorSet().pointColor);
                        userController.setName(_textEditingController.text);
                        setState(() {
                          isNameOk = true;
                        });
                      } else {
                        Get.snackbar("알림", "중복된 닉네임입니다.",
                            colorText: ColorSet().lightColor,
                            backgroundColor: ColorSet().pointColor);
                        setState(() {
                          isNameOk = false;
                        });
                      }
                    });
                  }
                },
                // 버튼에 텍스트 부여
                child: Text(
                  '확인',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget renderBody(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: Get.size.width,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
