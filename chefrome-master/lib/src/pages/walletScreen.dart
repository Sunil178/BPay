import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:markets/src/models/custom_fieldsss.dart';
import 'package:markets/src/models/user_transation.dart';
import 'package:markets/src/models/wallet_details.dart';
import 'package:markets/src/repository/passbook_repository.dart';
import 'package:markets/src/repository/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  String token;
  String id;

  WalletScreen({this.token, this.id});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  String amount = '0';
  String addAmount = '';
  String transType = '';
  String transAmount = '';
  String transId = ' ';
  Datum lol;
  List<Datum> llol = [];
  bool isLoading = true;
  Razorpay _razorpay;

  Future<void> getDetails() async {
    print(widget.id);
    print('i am o44545odd');
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}wallet/passbook';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({'user_id': widget.id}),
    );
    final WalletDetail walletDetail = walletDetailFromJson(response.body);
    setState(() {
      amount = walletDetail.data.ewalletAmount.toString();
    });
    print('resss' + walletDetail.data.email);
  }

  Future<void> userStatement() async {
    llol = [];
    print('user staaa');
    final String url =
        '${GlobalConfiguration().getString('api_base_url')}wallet/statement';
    final client = new http.Client();
    final response = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode({'user_id': widget.id}),
    );
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      print(response.statusCode);
      final UserTransaction userTransaction =
          UserTransaction.fromJson(json.decode(response.body));
      print('my res' + response.body);
      print('length' + userTransaction.data.length.toString());
      setState(() {
        for (int i = 0; i < userTransaction.data.length; i++) {
          print('ttyppee' + userTransaction.data[i].transactionType.toString());
          lol = Datum(
            transactionAmount: userTransaction.data[i].transactionAmount,
            transactionId: userTransaction.data[i].transactionId,
            transactionType: userTransaction.data[i].transactionType,
          );
          llol.add(lol);
        }
      });
    } else {
      throw new Exception(response.body);
    }
  }

  Future<void> showAddMoneyDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add money'),
            content: Form(
              key: _key,
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
                // onSaved: (value) => _money = value,
                decoration: InputDecoration(
                  labelText: 'amount',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  contentPadding: EdgeInsets.all(12),
                  hintText: '',
                  hintStyle: TextStyle(
                      color: Theme.of(context).focusColor.withOpacity(0.7)),
                  prefixIcon: Icon(Icons.lock_outline,
                      color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.5))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).focusColor.withOpacity(0.2))),
                ),
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  isLoading = true;
                  getDetails();
                  userStatement();
                },
                child: Text('Cancel'),
              ),
              RaisedButton(
                onPressed: () {
                  if (_key.currentState.validate()) {
                    _key.currentState.save();
                  }
                },
                child: Text('Continue'),
              ),
            ],
          );
        });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: MediaQuery.of(context).size.height * .6,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Money to Wallet',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              'Available Balance',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '₹ $amount',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Form(
                      key: _key,
                      child: TextFormField(
                        style: TextStyle(
                          fontSize: 32,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        onSaved: (value) => addAmount = value,
                        decoration: InputDecoration(
                          labelText: 'amount',
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                    ),
                    RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        onPressed: () {
                          if (_key.currentState.validate()) {
                            _key.currentState.save();
                            openCheckout();
                          }
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }

  void openCheckout() async {
    final key = Provider.of<CustomFieldsss>(context, listen: false).getRazorKey;
    print('sdsadsdsadasdsa'+ key);
    var options = {
      'key': '$key',
      'amount': int.parse(addAmount) * 100,
      'name': 'MultiVendor demo',
      'description': 'Wallet',
      'prefill': {
        'contact': '${currentUser.value.phone}',
        'email': '${currentUser.value.email}'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('done success');
    addMoney(int.parse(addAmount), 'RazorPay').then((value) {
      print('done done');
      Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId,
      );
      Navigator.pop(context);
      isLoading = true;
      getDetails();
      userStatement();
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('done fail');
    Fluttertoast.showToast(
      msg: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "EXTERNAL_WALLET: " + response.walletName,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getDetails();
    userStatement();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text(
          'My Wallet',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).accentColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Money'),
        icon: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
        onPressed: () {
          // showAddMoneyDialog(context);
          _settingModalBottomSheet(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body:
          // currentUser.value.apiToken == null
          //     ? PermissionDeniedWidget() :
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: Colors.green.shade300),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available Balance',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  '  ₹ $amount',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            CircleAvatar(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.green,
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              color: Colors.green.shade300),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Transactions',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    Icons.bar_chart,
                                    color: Colors.white,
                                    size: 40,
                                  )
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                height: 400,
                                child: ListView.builder(
                                    itemCount: llol.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: Icon(Icons.money,
                                            color: Colors.black),
                                        title: Text(
                                          '${llol[index].transactionType}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          '${llol[index].transactionId}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        trailing: Text(
                                          '  ₹ ${llol[index].transactionAmount.toString()}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
