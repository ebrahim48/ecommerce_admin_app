import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  static const routeName ="order-page";
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
      ),
    );
  }
}
