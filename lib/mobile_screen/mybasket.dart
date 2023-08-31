import 'package:flutter/material.dart';

class MyBasket extends StatelessWidget {
  const MyBasket({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      "My Basket",
      style: TextStyle(fontSize: 35.0),
    )));
  }
}
