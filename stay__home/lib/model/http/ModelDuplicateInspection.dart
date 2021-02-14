// To parse this JSON data, do
//
//     final modelDuplicateInspection = modelDuplicateInspectionFromJson(jsonString);

import 'dart:convert';

ModelDuplicateInspection modelDuplicateInspectionFromJson(String str) => ModelDuplicateInspection.fromJson(json.decode(str));

String modelDuplicateInspectionToJson(ModelDuplicateInspection data) => json.encode(data.toJson());

class ModelDuplicateInspection {
    ModelDuplicateInspection({
        this.success,
    });

    bool success;

    factory ModelDuplicateInspection.fromJson(Map<String, dynamic> json) => ModelDuplicateInspection(
        success: json["success"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
    };
}
