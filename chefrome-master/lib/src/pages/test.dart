import 'package:flutter/material.dart';
import 'package:markets/src/controllers/cart_controller.dart';

class Test extends StatelessWidget {
  CartController _con = CartController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(_con.total.toString()),),
    );
  }
}
