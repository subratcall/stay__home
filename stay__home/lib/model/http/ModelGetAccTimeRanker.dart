// To parse this JSON data, do
//
//     final getAccTimeRanker = getAccTimeRankerFromJson(jsonString);

import 'dart:convert';

GetAccTimeRanker getAccTimeRankerFromJson(String str) =>
    GetAccTimeRanker.fromJson(json.decode(str));

String getAccTimeRankerToJson(GetAccTimeRanker data) =>
    json.encode(data.toJson());

class GetAccTimeRanker {
  GetAccTimeRanker({
    this.success,
    this.data,
  });

  bool success;
  List<Datum> data;

  factory GetAccTimeRanker.fromJson(Map<String, dynamic> json) =>
      GetAccTimeRanker(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.accTime,
    this.id,
    this.name,
  });

  int accTime;
  String id;
  String name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        accTime: json["accTime"],
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "accTime": accTime,
        "_id": id,
        "name": name,
      };
}
