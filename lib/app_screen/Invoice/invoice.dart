import 'package:erp/CommonWidgets/CustomDataTable.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/service/asset/constants.dart';
import 'package:flutter/material.dart';

import '../../CommonWidgets/Button.dart';
import '../../CommonWidgets/DropDown.dart';
import '../../CommonWidgets/productTable.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InvoiceFormState();
  }
}

class _InvoiceFormState extends State<Invoice> {
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
      body: SizedBox(
        child: Container(
          margin: const EdgeInsets.all(0.0),
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 221, 239, 255)),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.black))),
                    child: const Text(
                      "Invoice",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    )),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 185,
                    width: 200,
                    child: Container(
                      margin: EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          // image: DecorationImage(
                          //     image: NetworkImage(
                          //         "https://picsum.photos/id/237/200/300"),
                          //     fit: BoxFit.cover),
                          color: Colors.amber),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Display Here Image",
                          style: TextStyle(color: Colors.black, fontSize: 25),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    width: 700,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Flexible(
                                      child: TextBox(helpText: "Cust Name")),
                                  Flexible(
                                      child: TextBox(helpText: "Cust Name")),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Flexible(
                                      child: TextBox(helpText: "Cust Name")),
                                  Flexible(
                                      child: TextBox(helpText: "Cust Name")),
                                ])
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 1),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  child: Container(
                                      width: 150,
                                      child: TextBox(
                                        helpText: "Item Number",
                                      ))),
                              SizedBox(
                                  child: Container(
                                      width: 450,
                                      child: TextBox(helpText: "Item Name"))),
                              SizedBox(
                                  child: Container(
                                      width: 150,
                                      child: TextBox(helpText: "HSN No"))),
                              SizedBox(
                                  child: Container(
                                      width: 150,
                                      child: TextBox(helpText: "Quantity"))),
                              SizedBox(
                                  width: 150,
                                  child: Container(
                                      child: Dropdown(
                                    helpText: "Unit",
                                  ))),
                              SizedBox(
                                  child: Container(
                                      width: 150,
                                      child: TextBox(helpText: "Rate"))),
                              SizedBox(
                                  child: Container(
                                      width: 150,
                                      child: TextBox(helpText: "Value"))),
                              SizedBox(
                                  width: 200,
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                              SizedBox(
                                width: 200,
                                child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
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
                                    )),
                              ),
                            ]),
                      ],
                    )),
              ),
              SizedBox(
                height: 400,
                width: double.infinity,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue.shade100),
                    margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: ProductTable(
                          columnList: _columnList, dataList: _dataList),
                    )),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.blue.shade100),
                    child: Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            SizedBox(
                                width: 400,
                                child: Text(
                                  "Total Items: ",
                                  style: TextStyle(
                                      fontSize: ConstantValues.customFontSize),
                                  textAlign: TextAlign.start,
                                )),
                            SizedBox(
                                width: 400,
                                child: Text(
                                  " ",
                                  style: TextStyle(
                                      fontSize: ConstantValues.customFontSize),
                                  textAlign: TextAlign.start,
                                )),
                            SizedBox(
                                width: 400,
                                child: Text(
                                  " ",
                                  style: TextStyle(
                                      fontSize: ConstantValues.customFontSize),
                                  textAlign: TextAlign.start,
                                )),
                            SizedBox(
                                width: 400,
                                child: Text(
                                  "Amount: ",
                                  style: TextStyle(
                                      fontSize: ConstantValues.customFontSize),
                                  textAlign: TextAlign.start,
                                )),
                          ],
                        ))),
              ),
              SizedBox(
                height: 75,
                width: double.infinity,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(1),
                        color: Colors.blue.shade100),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                width: 150,
                                margin: EdgeInsets.all(10),
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
                                  btnText: 'Save',
                                )),
                            SizedBox(
                              width: 150,
                              child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Button(
                                    onPress: () {
                                      showAboutDialog(
                                        context: context,
                                        applicationName: 'MenuBar Sample',
                                        applicationVersion: '1.0.0',
                                      );
                                    },
                                    btnColor: Colors.orange,
                                    textColor: Colors.white,
                                    btnText: 'Print',
                                  )),
                            ),
                            SizedBox(
                              width: 150,
                              child: Container(
                                  margin: EdgeInsets.all(10),
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
                                    btnText: 'Cancel',
                                  )),
                            ),
                          ],
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
