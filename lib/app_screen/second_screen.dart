import 'package:erp/mobile_screen/styles.dart';
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Second Page")),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            child: ElevatedButton(
              style: ElevatedButtonStyle.greenButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Navigate To previse page"),
            ),
          ),
        ));
  }
}
