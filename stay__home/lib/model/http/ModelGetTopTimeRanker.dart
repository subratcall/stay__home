// To parse this JSON data, do
//
//     final getTopTimeRanker = getTopTimeRankerFromJson(jsonString);

import 'dart:convert';

GetTopTimeRanker getTopTimeRankerFromJson(String str) =>
    GetTopTimeRanker.fromJson(json.decode(str));

String getTopTimeRankerToJson(GetTopTimeRanker data) =>
    json.encode(data.toJson());

class GetTopTimeRanker {
  GetTopTimeRanker({
    this.success,
    this.data,
  });

  bool success;
  List<Datun> data;

  factory GetTopTimeRanker.fromJson(Map<String, dynamic> json) =>
      GetTopTimeRanker(
        success: json["success"],
        data: List<Datun>.from(json["data"].map((x) => Datun.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datun {
  Datun({
    this.topTime,
    this.id,
    this.name,
  });

  int topTime;
  String id;
  String name;

  factory Datun.fromJson(Map<String, dynamic> json) => Datun(
        topTime: json["topTime"],
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "topTime": topTime,
        "_id": id,
        "name": name,
      };
}
