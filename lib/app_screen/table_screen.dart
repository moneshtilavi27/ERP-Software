import 'package:flutter/material.dart';

class MyTable extends StatelessWidget {
  const MyTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Table(
          border: TableBorder.all(),
          children: const [
            TableRow(children: [
              Text(
                "First Name",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "Last Name",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ]),
            TableRow(children: [
              Text(
                "Monesh",
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
              Text(
                "Tilavi",
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              )
            ]),
            TableRow(children: [
              Text(
                "Vikram",
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
              Text(
                "Patil",
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              )
            ]),
          ],
        ),
      ),
    );
  }
}
