// To parse this JSON data, do
//
//     final verifyReferalCode = verifyReferalCodeFromJson(jsonString);

import 'dart:convert';

VerifyReferalCode verifyReferalCodeFromJson(String str) => VerifyReferalCode.fromJson(json.decode(str));

String verifyReferalCodeToJson(VerifyReferalCode data) => json.encode(data.toJson());

class VerifyReferalCode {
  VerifyReferalCode({
    this.status,
    this.msg,
  });

  bool status;
  String msg;

  factory VerifyReferalCode.fromJson(Map<String, dynamic> json) => VerifyReferalCode(
    status: json["status"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
  };
}
