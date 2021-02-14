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
  getUserInfo() async {
    url = "http://15.164.195.117:3000/api/users/getUserInfo";
    response = await dio.get(url, queryParameters: {"name": "이영범"});
    responseList = json.decode(response.data);

    print(response.data.toString());
  }

  //  post
  updateName() async {
    url = "http://15.164.195.117:3000/api/users/updateName";
  }

  //  post
  updateTopTime() async {
    url = "http://15.164.195.117:3000/api/utils/updateTopTime";
  }

  //  post
  updateHomeAddress() async {
    url = "http://15.164.195.117:3000/api/utils/updateHomeAddress";
  }

  //  post
  insertAccTime() async {
    url = "http://15.164.195.117:3000/api/utils/insertAccTime";
  }

  //  get
  duplicateInspection(String name) async {
    url = "http://15.164.195.117:3000/api/utils/DuplicateInspection";
    response = await dio.get(url, queryParameters: {"name": name});
    print(response.data);
  }

  //  post
  createAccount({String name, double latitude, double longitude}) async {
    url = "http://15.164.195.117:3000/api/users/createAccount";
    response = await dio.post(url, queryParameters: {
      "name": name,
      "latitude": latitude,
      "longitude": longitude
    });
    print(response.data.toString());
  }
}
