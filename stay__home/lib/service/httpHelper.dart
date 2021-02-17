// import 'package:dio/dio.dart';

// class Https {
//   void getHttp(String url) async {
//     try {
//       Response response = await Dio().get(url);
//       print(response);
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:stay__home/model/http/ModelDuplicateInspection.dart';
import 'package:stay__home/model/http/ModelGetUserInfo.dart';
import 'package:stay__home/model/uesr.dart';

class HttpService {
  HttpService();

  String url = "";
  Response<String> response;
  Dio dio = new Dio();

  List<dynamic> responseList;

  //  get
  void getAllUserInfo() async {
    url = "http://15.164.195.117:3000/api/users/";
  }

  //  get
  Future<GetUserInfo> getUserInfo({
    @required String name,
  }) async {
    var jsonToData;
    url = "http://15.164.195.117:3000/api/users/getUserInfo";
    response = await dio.get(url, queryParameters: {"name": name});

    jsonToData = jsonDecode(response.data);
    return GetUserInfo.fromJson(jsonToData);
  }

  getUserInfo2({
    @required String name,
  }) async {
    Map<String, dynamic> jsonToData;
    url = "http://15.164.195.117:3000/api/users/getUserInfo";
    response = await dio.get(url, queryParameters: {"name": "이영범"});

    jsonToData = jsonDecode(response.data);
    print(jsonToData);
  }

  //  post
  Future<bool> updateName({
    @required String beforeName,
    @required String afterName,
  }) async {
    Map<String, dynamic> jsonToData;
    url = "http://15.164.195.117:3000/api/users/updateName";
    response = await dio.post(url,
        queryParameters: {"beforeName": beforeName, "afterName": afterName});
    jsonToData = jsonDecode(response.data);
    return jsonToData["success"];
  }

  //  post
  updateTopTime() async {
    url = "http://15.164.195.117:3000/api/utils/updateTopTime";
  }

  //  post
  Future<bool> updateHomeAddress(
      {@required String name,
      @required double latitude,
      @required double longitude}) async {
    Map<String, dynamic> jsonToData;
    url = "http://15.164.195.117:3000/api/utils/updateHomeAddress";
    response = await dio.post(url, queryParameters: {
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
    });
    jsonToData = jsonDecode(response.data);
    return jsonToData["success"];
  }

  //  post
  Future<bool> insertAccTime({
    @required String name,
    @required double resultTime,
  }) async {
    Map<String, dynamic> jsonToData;
    url = "http://15.164.195.117:3000/api/utils/insertAccTime";
    response = await dio.post(url, queryParameters: {
      "name": name,
      "resultTime": resultTime,
    });
    jsonToData = jsonDecode(response.data);
    return jsonToData["success"];
  }

  //  get
  Future<bool> duplicateInspection(String name) async {
    Map<String, dynamic> jsonToData;

    url = "http://15.164.195.117:3000/api/utils/DuplicateInspection";
    response = await dio.get(url, queryParameters: {
      "name": name,
    });
    jsonToData = jsonDecode(response.data);
    return jsonToData["success"];
  }

  //  post
  Future<bool> createAccount({
    @required String name,
    @required double latitude,
    @required double longitude,
  }) async {
    Map<String, dynamic> jsonToData;

    url = "http://15.164.195.117:3000/api/users/createAccount";
    response = await dio.post(url, queryParameters: {
      "name": name,
      "latitude": latitude,
      "longitude": longitude,
    });
    jsonToData = jsonDecode(response.data);
    print(response.data.toString());
    return jsonToData["success"];
  }

  Future<String> translateAddress({
    @required double latitude,
    @required double longitude,
  }) async {
    Map<String, dynamic> jsonToData;
    url = "http://apis.vworld.kr/coord2new.do?";
    response = await dio.get(url, queryParameters: {
      "x": longitude,
      "y": latitude,
      "apiKey": "74F86569-69D2-3A9D-A217-CBBA729FEFB5",
      "output": "json",
      "epsg": "epsg:4326",
    });
    jsonToData = jsonDecode(response.data);
    print(jsonToData["NEW_JUSO"]);

    return jsonToData["NEW_JUSO"];
  }
}
