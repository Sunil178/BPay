// To parse this JSON data, do
//
//     final walletDetail = walletDetailFromJson(jsonString);

import 'dart:convert';

WalletDetail walletDetailFromJson(String str) => WalletDetail.fromJson(json.decode(str));

String walletDetailToJson(WalletDetail data) => json.encode(data.toJson());

class WalletDetail {
  WalletDetail({
    this.status,
    this.msg,
    this.data,
  });

  bool status;
  String msg;
  Data data;

  factory WalletDetail.fromJson(Map<String, dynamic> json) => WalletDetail(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.ewalletPassbookId,
    this.transactionId,
    this.message,
    this.transactionType,
    this.name,
    this.email,
    this.ewalletAmount,
  });

  int ewalletPassbookId;
  String transactionId;
  String message;
  String transactionType;
  String name;
  String email;
  double ewalletAmount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ewalletPassbookId: json["ewallet_passbook_id"],
    transactionId: json["transaction_id"],
    message: json["message"],
    transactionType: json["transaction_type"],
    name: json["name"],
    email: json["email"],
    ewalletAmount: json["ewallet_amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ewallet_passbook_id": ewalletPassbookId,
    "transaction_id": transactionId,
    "message": message,
    "transaction_type": transactionType,
    "name": name,
    "email": email,
    "ewallet_amount": ewalletAmount,
  };
}
