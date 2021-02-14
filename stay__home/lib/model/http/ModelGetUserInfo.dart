// To parse this JSON data, do
//
//     final modelGetUserInfo = modelGetUserInfoFromJson(jsonString);

import 'dart:convert';

ModelGetUserInfo modelGetUserInfoFromJson(String str) => ModelGetUserInfo.fromJson(json.decode(str));

String modelGetUserInfoToJson(ModelGetUserInfo data) => json.encode(data.toJson());

class ModelGetUserInfo {
    ModelGetUserInfo({
        this.success,
        this.data,
    });

    bool success;
    Data data;

    factory ModelGetUserInfo.fromJson(Map<String, dynamic> json) => ModelGetUserInfo(
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

    int latitude;
    int longitude;
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
