// To parse this JSON data, do
//
//     final getUserInfo = getUserInfoFromJson(jsonString);

import 'dart:convert';

GetUserInfo getUserInfoFromJson(String str) =>
    GetUserInfo.fromJson(json.decode(str));

String getUserInfoToJson(GetUserInfo data) => json.encode(data.toJson());

class GetUserInfo {
  GetUserInfo({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory GetUserInfo.fromJson(Map<String, dynamic> json) => GetUserInfo(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.latitude,
    this.longitude,
    this.id,
    this.name,
    this.accTime,
    this.topTime,
    this.eventLog,
    this.v,
  });

  double latitude;
  double longitude;
  String id;
  String name;
  int accTime;
  int topTime;
  List<dynamic> eventLog;
  int v;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        latitude: json["latitude"],
        longitude: json["longitude"],
        id: json["_id"],
        name: json["name"],
        accTime: json["accTime"],
        topTime: json["topTime"],
        eventLog: List<dynamic>.from(json["eventLog"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "_id": id,
        "name": name,
        "accTime": accTime,
        "topTime": topTime,
        "eventLog": List<dynamic>.from(eventLog.map((x) => x)),
        "__v": v,
      };
}
