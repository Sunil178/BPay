// To parse this JSON data, do
//
//     final driverDetails = driverDetailsFromJson(jsonString);

import 'dart:convert';

DriverDetails driverDetailsFromJson(String str) => DriverDetails.fromJson(json.decode(str));

String driverDetailsToJson(DriverDetails data) => json.encode(data.toJson());

class DriverDetails {
  DriverDetails({
    this.status,
    this.msg,
    this.data,
  });

  bool status;
  String msg;
  Data data;

  factory DriverDetails.fromJson(Map<String, dynamic> json) => DriverDetails(
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
    this.id,
    this.name,
    this.email,
    this.ewalletAmount,
    this.password,
    this.apiToken,
    this.deviceToken,
    this.stripeId,
    this.cardBrand,
    this.cardLastFour,
    this.trialEndsAt,
    this.braintreeId,
    this.paypalEmail,
    this.rememberToken,
    this.userReferCode,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.deliveryFee,
    this.totalOrders,
    this.earning,
    this.available,
    this.value,
    this.view,
    this.customFieldId,
    this.customizableType,
    this.customizableId,
  });

  int id;
  String name;
  String email;
  int ewalletAmount;
  String password;
  String apiToken;
  String deviceToken;
  dynamic stripeId;
  dynamic cardBrand;
  dynamic cardLastFour;
  dynamic trialEndsAt;
  dynamic braintreeId;
  dynamic paypalEmail;
  dynamic rememberToken;
  dynamic userReferCode;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;
  int deliveryFee;
  int totalOrders;
  int earning;
  int available;
  String value;
  String view;
  int customFieldId;
  String customizableType;
  int customizableId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    ewalletAmount: json["ewallet_amount"],
    password: json["password"],
    apiToken: json["api_token"],
    deviceToken: json["device_token"],
    stripeId: json["stripe_id"],
    cardBrand: json["card_brand"],
    cardLastFour: json["card_last_four"],
    trialEndsAt: json["trial_ends_at"],
    braintreeId: json["braintree_id"],
    paypalEmail: json["paypal_email"],
    rememberToken: json["remember_token"],
    userReferCode: json["user_refer_code"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
    deliveryFee: json["delivery_fee"],
    totalOrders: json["total_orders"],
    earning: json["earning"],
    available: json["available"],
    value: json["value"],
    view: json["view"],
    customFieldId: json["custom_field_id"],
    customizableType: json["customizable_type"],
    customizableId: json["customizable_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "ewallet_amount": ewalletAmount,
    "password": password,
    "api_token": apiToken,
    "device_token": deviceToken,
    "stripe_id": stripeId,
    "card_brand": cardBrand,
    "card_last_four": cardLastFour,
    "trial_ends_at": trialEndsAt,
    "braintree_id": braintreeId,
    "paypal_email": paypalEmail,
    "remember_token": rememberToken,
    "user_refer_code": userReferCode,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user_id": userId,
    "delivery_fee": deliveryFee,
    "total_orders": totalOrders,
    "earning": earning,
    "available": available,
    "value": value,
    "view": view,
    "custom_field_id": customFieldId,
    "customizable_type": customizableType,
    "customizable_id": customizableId,
  };
}
