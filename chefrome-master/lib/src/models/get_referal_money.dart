// To parse this JSON data, do
//
//     final getReferalAmount = getReferalAmountFromJson(jsonString);

import 'dart:convert';

GetReferalAmount getReferalAmountFromJson(String str) => GetReferalAmount.fromJson(json.decode(str));

String getReferalAmountToJson(GetReferalAmount data) => json.encode(data.toJson());

class GetReferalAmount {
  GetReferalAmount({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  String data;
  String message;

  factory GetReferalAmount.fromJson(Map<String, dynamic> json) => GetReferalAmount(
    success: json["success"],
    data: json["data"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "message": message,
  };
}
