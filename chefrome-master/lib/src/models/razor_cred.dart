// To parse this JSON data, do
//
//     final getRazorCred = getRazorCredFromJson(jsonString);

import 'dart:convert';

GetRazorCred getRazorCredFromJson(String str) =>
    GetRazorCred.fromJson(json.decode(str));

String getRazorCredToJson(GetRazorCred data) => json.encode(data.toJson());

class GetRazorCred {
  GetRazorCred({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory GetRazorCred.fromJson(Map<String, dynamic> json) => GetRazorCred(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
        "message": message,
      };
}

class Data {
  Data({this.key, this.secrate, this.max_coupon});

  String key;
  String secrate;
  String max_coupon;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      key: json["key"],
      secrate: json["secrate"],
      max_coupon: json["max_coupon"]);

  Map<String, dynamic> toJson() =>
      {"key": key, "secrate": secrate, "max_coupon": max_coupon};
}
