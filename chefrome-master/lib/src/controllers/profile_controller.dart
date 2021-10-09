import 'package:flutter/material.dart';
import 'package:markets/src/models/passbook.dart';
import 'package:markets/src/repository/passbook_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/order.dart';
import '../repository/order_repository.dart';

class ProfileController extends ControllerMVC {

  List<Order> recentOrders = [];
  List transaction = [];
  List transactionCredit = [];
  GlobalKey<ScaffoldState> scaffoldKey;
  bool isLoading = true;
  PassBookDetails passBookDetails = PassBookDetails();

  ProfileController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForRecentOrders();
    getStatements();
    getStatementsCredit();
    getPassbookDetails();
  }

  void listenForRecentOrders({String message}) async {
    print('##################');
    final Stream<Order> stream = await getRecentOrders();
    stream.listen((Order _order) {
      setState(() {
        recentOrders.add(_order);
      });
    }, onError: (a) {
      print(a);
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> getPassbookDetails() async {
    var result = await getDetails().then((result){
      print(result);
      passBookDetails = result;
      setState(() {isLoading = !isLoading;
      });
    });
  }
  Future<void> getStatements() async {
    var result = await userStatement().then((result){
      setState(() {
        transaction = result.data['data'];

      });
    });
  }
  Future<void> getStatementsCredit() async {
    var result = await userStatementCredit().then((result){
      setState(() {
        transactionCredit = result.data['data'];

      });
    });
  }
  Future<void> refreshProfile() async {
    recentOrders.clear();
    listenForRecentOrders(message: S.of(context).orders_refreshed_successfuly);
  }
}
