import 'package:erp/CommonWidgets/common.dart';
import 'package:flutter/material.dart';

import '../CommonWidgets/Button.dart';

class SubmitScreen extends StatefulWidget {
  final String title;

  const SubmitScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _submitScreenState();
}

class _submitScreenState extends State<SubmitScreen> {
  TextEditingController total_item = TextEditingController();
  int totalItems = 5; // Replace with actual total items
  double totalAmount = 1000; // Replace with actual total amount
  double gst = 18; // Replace with actual GST percentage
  double discount = 0;
  double fontSize = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    style: TextStyle(fontSize: fontSize),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(fontSize: fontSize),
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      contentPadding: EdgeInsets.only(left: 10),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    style: TextStyle(fontSize: fontSize),
                    decoration: const InputDecoration(
                      labelText: 'Adress',
                      contentPadding: EdgeInsets.only(left: 10),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 5),
                  billTiles("Total Items", controller: total_item),
                  const Divider(height: 5),
                  billTiles("Total Amount:", controller: total_item),
                  const Divider(height: 5),
                  billTiles("CGST", controller: total_item),
                  const Divider(height: 5),
                  billTiles("SGST", controller: total_item),
                  const Divider(height: 5),
                  billTiles("Net Bill", controller: total_item),
                  const Divider(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: ListTile(
                      leading: Text(
                        "Net Amount",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Padding(
                        padding: EdgeInsets.only(right: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.currency_rupee_rounded),
                            Text(
                              "5000.00",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 162, 55, 28),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 5),
                  const SizedBox(height: 10),
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 250,
                        child: Button(
                          onPress: () {
                            Common cm = Common();
                            cm.showPrintPreview(context);
                          },
                          btnColor: Colors.orange,
                          textColor: Colors.white,
                          btnText: 'Print / Save',
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}

class billTiles extends StatelessWidget {
  final String textTitle;
  final TextEditingController controller;
  final double fontSize = 12;
  const billTiles(this.textTitle, {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSize),
          ),
          SizedBox(
            width: 130,
            child: TextFormField(
              style: TextStyle(fontSize: fontSize),
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: "0.0",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }
}
