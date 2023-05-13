import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Second Page")),
        body: Center(
          child: Container(
            margin: EdgeInsets.all(24),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // background (button) color
                foregroundColor: Colors.white, //
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Navigate To previse page"),
            ),
          ),
        ));
  }
}
