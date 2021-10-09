import 'dart:convert';
import 'dart:io';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:markets/src/models/custom_fieldsss.dart';
import 'package:markets/src/models/selected_option.dart';
import 'package:markets/src/models/total_provider.dart';
import 'package:markets/src/models/user_detailss.dart';
import 'package:markets/src/models/wallet_details.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../elements/PaymentMethodListItemWidget.dart';
import '../elements/SearchBarWidget.dart';
import '../elements/ShoppingCartButtonWidget.dart';
import '../models/payment_method.dart';
import '../models/route_argument.dart';
import '../repository/settings_repository.dart';
import 'order_success.dart';

class PaymentMethodsWidget extends StatefulWidget {
  final RouteArgument routeArgument;

  PaymentMethodsWidget({Key key, this.routeArgument}) : super(key: key);

  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState extends State<PaymentMethodsWidget> {
  bool isLoading = false;
  PaymentMethodList list;
  String id = '';
  String wallet_amount = '';
  double total = 0;
  String option;

  Future<void> getDetails() async {
    print(id);
    print('i am o44545odd');
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}wallet/passbook';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({'user_id': '$id'}),
    );
    final WalletDetail walletDetail = walletDetailFromJson(response.body);
    setState(() {
      wallet_amount = walletDetail.data.ewalletAmount.toString();
    });
    print('resss' + walletDetail.data.email);
  }

  Future<void> useWallet() async {
    print(wallet_amount);
    print(double.parse(wallet_amount));
    if (double.parse(wallet_amount) > 0) {
      if (double.parse(wallet_amount) >= total) {
        setState(() {
          isLoading = true;
        });
        final String url =
            '${GlobalConfiguration().getString('api_base_url')}wallet/sub';
        final client = new http.Client();
        final response = await client.post(
          url,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: json.encode({
            'user_id': '$id',
            'amount': '${total}',
            'deduction_for': 'order '
          }),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          if (double.parse(wallet_amount) > total) {
            Provider.of<CustomFieldsss>(context, listen: false).setIsWallet(1);
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              if (option == 'delivery') {
                return OrderSuccessWidget(
                  routeArgument: RouteArgument(param: 'CashOnDelivery'),
                );
              } else {
                return OrderSuccessWidget(
                  routeArgument: RouteArgument(param: 'Pay on Pickup'),
                );
              }
            }));
          } else {
            // _con.total = _con.total - double.parse(amount);
            // amount = '0.0';
            // Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Please recharge your wallet');
            return;
          }
        }
      } else {
        Fluttertoast.showToast(msg: 'Please recharge your wallet');
      }
    } else {
      Fluttertoast.showToast(msg: 'Please recharge your wallet');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    option = Provider.of<SelectedOption>(context, listen: false).getOption();
    total = Provider.of<TotalProvider>(context, listen: false).getTotal();
    id = Provider.of<UserDetails>(context, listen: false).userId;
    getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    list = new PaymentMethodList(context);
    if (isLoading == false) {
      if (!setting.value.payPalEnabled)
        list.paymentsList.removeWhere((element) {
          return element.id == "paypal";
        });
      if (!setting.value.razorPayEnabled)
        list.paymentsList.removeWhere((element) {
          return element.id == "razorpay";
        });
      if (!setting.value.stripeEnabled)
        list.paymentsList.removeWhere((element) {
          return element.id == "visacard" || element.id == "mastercard";
        });
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            S.of(context).payment_mode,
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
          actions: <Widget>[
            new ShoppingCartButtonWidget(
                iconColor: Theme.of(context).hintColor,
                labelColor: Theme.of(context).accentColor),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: SearchBarWidget(),
              // ),
              SizedBox(height: 15),
              list.paymentsList.length > 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.payment,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          S.of(context).payment_options,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        subtitle: Text(
                            S.of(context).select_your_preferred_payment_mode),
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
              SizedBox(height: 10),
              ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: list.paymentsList.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return PaymentMethodListItemWidget(
                      paymentMethod: list.paymentsList.elementAt(index));
                },
              ),
              SizedBox(
                height: 16,
              ),
              ExpandablePanel(
                header: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          image: DecorationImage(
                              image: AssetImage('assets/img/wallet.png'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(width: 15),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Wallet',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  Text(
                                    S.of(context).click_to_pay_with_your_wallet,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                expanded: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  // height: 100,
                  // color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      ListTile(
                        leading: Icon(Icons.wallet_travel_outlined),
                        title: Text('Available balance'),
                        trailing: Text('₹ $wallet_amount'),
                      ),
                      RaisedButton(
                          child: Text(
                            'Pay',
                          ),
                          textColor: Theme.of(context).primaryColor,
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            useWallet();
                          }),
                    ],
                  ),
                ),
                tapHeaderToExpand: true,
                hasIcon: true,
              ),
              option == 'delivery'
                  ? list.cashList.length > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                            leading: Icon(
                              Icons.monetization_on,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              S.of(context).cash_on_delivery,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(S
                                .of(context)
                                .select_your_preferred_payment_mode),
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        )
                  : SizedBox(),
              option == 'delivery'
                  ? ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: list.cashList.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return PaymentMethodListItemWidget(
                            paymentMethod: list.cashList.elementAt(index));
                      },
                    )
                  : SizedBox()
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          // color: Colors.red,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please wait while we process your payment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(
                height: 64,
              ),
              Container(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            ],
          ),
        ),
      );
    }
  }
}
