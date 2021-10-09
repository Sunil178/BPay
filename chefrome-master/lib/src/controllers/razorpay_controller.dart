import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:markets/src/models/total_provider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;

class RazorPayController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  InAppWebViewController webView;
  String url = "";
  double progress = 0;
  Address deliveryAddress;

  // String _delivery_or_pickup ='_delivery_or_pickup=0';

  RazorPayController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    print(settingRepo.deliveryAddress.value.id);
    final String _apiToken = 'api_token=${userRepo.currentUser.value.apiToken}';
    final String _deliveryAddress =
        'delivery_address_id=${settingRepo.deliveryAddress.value.id == 'null' ? 24 : settingRepo.deliveryAddress.value.id}';
    final String _couponCode = 'coupon_code=${settingRepo.coupon?.code}';
    url =
        '${GlobalConfiguration().getString('base_url')}payments/razorpay/checkout?$_apiToken&$_deliveryAddress&$_couponCode';
    print('razorpayy' + url);
    setState(() {});
    super.initState();
  }
}
