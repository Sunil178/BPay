import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:markets/src/models/custom_fieldsss.dart';
import 'package:markets/src/models/get_referal_money.dart';
import 'package:markets/src/models/razor_cred.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;
  bool isLoading = true;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    getRazorKey();
  }

  void getRazorKey() async {
    String url = '${GlobalConfiguration().getString('api_base_url')}razorcred';
    var res = await http.get(url);

    if (res.statusCode == 200) {
      final getRazorCred = getRazorCredFromJson(res.body);
      print(getRazorCred.data.max_coupon);
      Provider.of<CustomFieldsss>(context, listen: false)
          .setKey(getRazorCred.data.key);
      Provider.of<CustomFieldsss>(context, listen: false)
          .setMaxCouponPrice(getRazorCred.data.max_coupon);
      getReferalMoney();
    } else {
      Fluttertoast.showToast(msg: 'Please add RazorPay key');
    }
    print(res.body);
  }

  void getReferalMoney() async {
    String url =
        '${GlobalConfiguration().getString('api_base_url')}referralmoney';
    var res = await http.get(url);
    if (res.statusCode == 200) {
      final getReferalAmount = getReferalAmountFromJson(res.body);
      Provider.of<CustomFieldsss>(context, listen: false)
          .setMoney(getReferalAmount.data);
      loadData();
    }
    print(res.body);
  }

  void loadData() {
    print(' i am in');
    _con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress == 100) {
        try {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        } catch (e) {}
      }
    });
    Future.delayed(Duration(seconds: 5)).then((value) {
      print('feqfqwfwefewf');
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _con.scaffoldKey,
        body: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/img/logo.png',
                  width: 450,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 50),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).hintColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
