import 'package:flutter/cupertino.dart';

class CustomFieldsss  {
  String _referalMoney;
  String _razorKey;
  String _maxCouponPrice;
  int _isWallet;
  bool _isPressed = true;
  // String _getCartCount;
  //
  //
  // void setCountCount(String count){
  //   _getCartCount = count;
  //   notifyListeners();
  // }
  //
  // String get getCartCount{
  //   return getCartCount;
  // }


  void setIsPressed(bool press){
    _isPressed = press;
  }

  bool get getIsPressed{
    return _isPressed;
  }

  void setIsWallet(int status) {
    _isWallet = status;
  }

  int get getIswallet {
    return _isWallet;
  }

  void setMoney(String m) {
    _referalMoney = m;
  }

  String get getReferalMoney {
    return _referalMoney;
  }

  void setKey(String key) {
    _razorKey = key;
  }

  String get getRazorKey {
    return _razorKey;
  }

  void setMaxCouponPrice(String price) {
    _maxCouponPrice = price;
  }

  double get getMaxDiscountPrice {
    return double.parse(_maxCouponPrice);
  }
}
