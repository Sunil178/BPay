// To parse this JSON data, do
//
//     final userTransaction = userTransactionFromJson(jsonString);

import 'dart:convert';

UserTransaction userTransactionFromJson(String str) => UserTransaction.fromJson(json.decode(str));

String userTransactionToJson(UserTransaction data) => json.encode(data.toJson());

class UserTransaction {
  UserTransaction({
    this.status,
    this.msg,
    this.data,
  });

  bool status;
  String msg;
  List<Datum> data;

  factory UserTransaction.fromJson(Map<String, dynamic> json) => UserTransaction(
    status: json["status"],
    msg: json["msg"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.ewalletPassbookId,
    this.transactionId,
    this.message,
    this.transactionType,
    this.transactionAmount,
  });

  int ewalletPassbookId;
  String transactionId;
  String message;
  String transactionType;
  double transactionAmount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    ewalletPassbookId: json["ewallet_passbook_id"],
    transactionId: json["transaction_id"],
    message: json["message"],
    transactionType: json["transaction_type"],
    transactionAmount: json["transaction_amount"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "ewallet_passbook_id": ewalletPassbookId,
    "transaction_id": transactionId,
    "message": message,
    "transaction_type": transactionType,
    "transaction_amount": transactionAmount,
  };
}


