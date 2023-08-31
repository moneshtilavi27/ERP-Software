import 'package:flutter/material.dart';

class SimpleForm extends StatefulWidget {
  const SimpleForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SimpleFormState();
  }
}

class _SimpleFormState extends State<SimpleForm> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simle Form")),
      body: Container(
        margin: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            TextField(
              onSubmitted: (String username) {
                setState(() {
                  name = username;
                });
              },
            ),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Name is $name",
                  style: const TextStyle(fontSize: 15.0),
                ))
          ],
        ),
      ),
    );
  }
}
