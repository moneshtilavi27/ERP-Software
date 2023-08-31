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
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Adress',
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
                    padding: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Text(
                        "Net Amount",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
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
                                  fontSize: 24,
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
                            // callAPI();
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
  const billTiles(this.textTitle, {super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          SizedBox(
            width: 150,
            child: TextFormField(
              controller: controller,
              decoration: const InputDecoration(
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
