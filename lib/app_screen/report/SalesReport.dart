import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:flutter/material.dart';

import '../../CommonWidgets/Button.dart';
import '../../CommonWidgets/DropDown.dart';
import '../../CommonWidgets/productTable.dart';

class SalesReport extends StatefulWidget {
  const SalesReport({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SalesReportFormState();
  }
}

class _SalesReportFormState extends State<SalesReport> {
  late TextEditingController _custName;
  String name = "";

  late final List _dataList = [
    {'bid': '1', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': '1', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
    {'bid': 'bid', 'busName': 'monesh', 'busNumber': 'KA22BA123', 'b_seat': 20},
  ];

  final List<Map<String, String>> _columnList = [
    {'title': 'item Number', 'key': 'bid', 'width': '220.0'},
    {'title': 'item Name', 'key': 'busName', 'width': '400.0'},
    {'title': 'HSN No', 'key': 'busNumber', 'width': '250.0'},
    {'title': 'Quantity', 'key': 'b_seat', 'width': '225.0'},
    {'title': 'Rate', 'key': 'b_seat', 'width': '225.0'},
    {'title': 'Value', 'key': 'b_seat', 'width': '225.0'},
  ];

  List<Map<String, String>> getDataList() {
    // Sample data for the table
    return [
      {'Name': 'John', 'Age': '25', 'Country': 'USA'},
      {'Name': 'Alice', 'Age': '30', 'Country': 'Canada'},
      {'Name': 'Bob', 'Age': '22', 'Country': 'UK'},
      // Add more data as needed
    ];
  }

  @override
  void initState() {
    super.initState();
    _custName = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(0.0),
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 221, 239, 255)),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black))),
                child: const Text(
                  "Sales Report",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                )),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 1),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                              child: SizedBox(
                                  width: 150,
                                  child: TextBox(
                                    helpText: "Item Number",
                                  ))),
                          SizedBox(
                              child: SizedBox(
                                  width: 450,
                                  child: TextBox(helpText: "Item Name"))),
                          SizedBox(
                              child: SizedBox(
                                  width: 150,
                                  child: TextBox(helpText: "HSN No"))),
                          Flexible(
                              child: SizedBox(
                                  width: 150,
                                  child: TextBox(helpText: "Quantity"))),
                          SizedBox(
                              child: SizedBox(
                                  width: 150,
                                  child: Dropdown(
                                    helpText: "Unit",
                                    defaultValue: '-',
                                  ))),
                          SizedBox(
                              child: SizedBox(
                                  width: 150,
                                  child: TextBox(helpText: "Rate"))),
                          SizedBox(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  width: 200,
                                  child: Button(
                                    onPress: () {
                                      showAboutDialog(
                                        context: context,
                                        applicationName: 'MenuBar Sample',
                                        applicationVersion: '1.0.0',
                                      );
                                    },
                                    btnColor: Colors.green,
                                    textColor: Colors.white,
                                    btnText: 'Add',
                                  ))),
                          Flexible(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                                  width: 200,
                                  child: Button(
                                    onPress: () {
                                      showAboutDialog(
                                        context: context,
                                        applicationName: 'MenuBar Sample',
                                        applicationVersion: '1.0.0',
                                      );
                                    },
                                    btnColor: Colors.red,
                                    textColor: Colors.white,
                                    btnText: 'Delete',
                                  ))),
                        ]),
                  ],
                )),
            SizedBox(
              height: 730,
              width: double.infinity,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.blue.shade100),
                  margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ProductTable(
                        columnList: _columnList, dataList: _dataList),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
