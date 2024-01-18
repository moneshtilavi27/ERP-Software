import 'package:erp/app_screen/second_screen.dart';
import 'package:erp/mobile_screen/styles.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Fist Page")),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: const Text("Button CLicked Dailog"),
                              content: const Text("Button CLicked Dailog"),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Colors.green,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("Okay",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Colors.red,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text(
                                        "Cancle",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ],
                            ));
                  },
                  child: const Text("Show alert Dialog box"),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(24),
                child: ElevatedButton(
                  style: ElevatedButtonStyle.greenButtonStyle,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SecondScreen(),
                      ),
                    );
                  },
                  child: const Text("Navigate To next page"),
                ),
              ),
            ],
          ),
        ));
  }
}
