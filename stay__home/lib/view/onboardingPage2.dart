import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stay__home/controller/LocationController.dart';

class OnboardingPage2 extends StatefulWidget {
  @override
  _OnboardingPageState2 createState() => _OnboardingPageState2();
}

class _OnboardingPageState2 extends State<OnboardingPage2> {
  bool isOk = false;
  int state = 0;
  String tileText;
  final _formKey = GlobalKey<FormState>();
  Position position;

  String latitudeData = "";
  String longitudeData = "";

  DateTime startTime;
  DateTime endTime;
  int resultTime;

  DateTime virtualTime;

  final locationcontroller = Get.put(LoactionController());
  @override
  void initState() {
    super.initState();
    isOk = false;
    locationcontroller.determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: renderSecondPage(),
        ),
        bottomNavigationBar: GetBuilder<LoactionController>(
          builder: (_) {
            if (_.longitudeData != 0.0 ||
                _.latitudeData != 0.0 ) {
              isOk = true;
            } else {
              isOk = false;
            }
            return BottomAppBar(
              child: Container(
                height: 55,
                color: isOk ? Colors.cyan : Colors.grey,
                child: CupertinoButton(
                  disabledColor: Colors.grey,
                  onPressed: isOk
                      ? () {
                          Get.toNamed('/');
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
        ));
  }

  Widget renderSecondPage() {
    return Container(
      alignment: Alignment.center,
      child: state == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                renderTitle("사용하실 닉네임을 입력해 주세요"),
                SizedBox(
                  height: 20,
                ),
                renderNameForm(),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                renderTitle("집의 위치를 설정해주세요"),
                SizedBox(
                  height: 20,
                ),
                renderLocation(),
              ],
            ),
    );
  }

  Widget renderLocation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          // leading: Icon(Icons.location_on_outlined, color: Colors.white),
          onTap: () async {
            await locationcontroller.setHome();
          },
          title: Text(
            "현재 위치를 집으로 설정합니다",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: GetBuilder<LoactionController>(
            builder: (_) {
              if (_.longitudeData == 0.0 || _.latitudeData == 0.0) {
                tileText = "클릭으로 위치를 지정해 주세요.";
              } else {
                tileText =
                    "${_.longitudeData.toString()}, ${_.latitudeData.toString()}";
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
                color: Colors.cyan,
                onPressed: () {
                  // 텍스트폼필드의 상태가 적함하는
                  if (_formKey.currentState.validate()) {
                    // 스낵바를 통해 메시지 출력
                    // Get.snackbar("title", "message");
                    setState(() {
                      state = 1;
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
