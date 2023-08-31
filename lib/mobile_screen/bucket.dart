import 'package:erp/mobile_screen/submitPage.dart';
import 'package:flutter/material.dart';

import '../CommonWidgets/Button.dart';

class Bucket extends StatefulWidget {
  Bucket({Key? key, required this.title}) : super(key: key);
  final String title;
  String dropdownValue = "";
  @override
  State<Bucket> createState() => _BucketState();
}

class _BucketState extends State<Bucket> {
  var isLoading = false;

  late List products = [
    {
      "item_id": "1",
      "name": "HALDI POWDER SPARSH 5/-",
      "item_hsn": "0910",
      "item_gst": "5",
      "item_unit": "pkt",
      "basic_value": "3.2",
      "whole_sale_value": "3.2"
    },
    {
      "item_id": "2",
      "name": "DHANIYA POWDER SPARSH 500GM",
      "item_hsn": "0909",
      "item_gst": "",
      "item_unit": "pkt",
      "basic_value": "70",
      "whole_sale_value": "70"
    },
    {
      "item_id": "3",
      "name": "DHANIYA POWDER SPARSH 200GM",
      "item_hsn": "0909",
      "item_gst": "",
      "item_unit": "pkt",
      "basic_value": "28",
      "whole_sale_value": "28"
    },
    {
      "item_id": "4",
      "name": "DHANIYA POWDER SPARSH 100GM",
      "item_hsn": "0909",
      "item_gst": "",
      "item_unit": "pkt",
      "basic_value": "140",
      "whole_sale_value": "140"
    },
    {
      "item_id": "5",
      "name": "DHANIYA POWDER SPARSH 50GM",
      "item_hsn": "0909",
      "item_gst": "",
      "item_unit": "pkt",
      "basic_value": "7",
      "whole_sale_value": "7"
    },
    {
      "item_id": "6",
      "name": "HALDI POWDER SPARSH 200GM",
      "item_hsn": "0910",
      "item_gst": "",
      "item_unit": "pkt",
      "basic_value": "28",
      "whole_sale_value": "28"
    },
    {
      "item_id": "7",
      "name": "HALDI POWDER SPARSH 100GM",
      "item_hsn": "0910",
      "item_gst": "",
      "item_unit": "pkt",
      "basic_value": "14",
      "whole_sale_value": "14"
    }
  ];
  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() {
    setState(() {
      isLoading = false;
    });
  }

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
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          ListTile(
                            tileColor: Colors.white,
                            title: Text(
                              products[index]['name'],
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            subtitle: Text(products[index]['item_hsn'],
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.currency_rupee_rounded),
                                Text(
                                  products[index]['basic_value'] +
                                      " / " +
                                      products[index]['item_unit'],
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 162, 55, 28),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            onTap: () {},
                            onLongPress: () {},
                          ),
                          const Divider(
                            height: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                  // Amount and Next Button
                  _buildBottomWidget(),
                ],
              ));
  }

  Widget _buildBottomWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: ', // Replace with your actual amount
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 162, 55, 28),
                ),
              ),
              Icon(
                Icons.currency_rupee_rounded,
                color: Color.fromARGB(255, 162, 55, 28),
              ),
              Text(
                "500",
                style: TextStyle(
                    color: Color.fromARGB(255, 162, 55, 28),
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            width: 200,
            child: Button(
              onPress: () {
                // callAPI();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SubmitScreen(title: "Bill Screen")));
              },
              btnColor: Colors.orange,
              textColor: Colors.white,
              btnText: 'Next',
            ),
          )
        ],
      ),
    );
  }
}
