import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_bloc.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_state.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_state.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/mobile_screen/submitPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        body: BlocBuilder<InvoiceBloc, InvoiceState>(builder: (context, state) {
          if (state is InvoiceItemListState) {
            return isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemCount: state.dataList.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              title: Text(
                                state.dataList[index]['item_name'],
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(state.dataList[index]['item_hsn'],
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
                                    state.dataList[index]['basic_value'] +
                                        " / " +
                                        state.dataList[index]['item_unit'],
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 162, 55, 28),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showItemInputDialog(
                                    context, state.dataList[index]);
                              },
                              onLongPress: () {},
                            ),
                            const Divider(
                              height: 5,
                            )
                          ],
                        ),
                      )),
                      // Amount and Next Button
                      _buildBottomWidget(),
                    ],
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
        bottomSheet: BlocBuilder<NetworkBloc, NetworkState>(
          builder: (context, state) {
            if (state is NetworkFailure) {
              return InternetStatusMessage(
                isConnected: false,
              );
            } else if (state is NetworkSuccess) {
              return InternetStatusMessage(
                isConnected: true,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
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
                  fontSize: 18,
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
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            width: 100,
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

  Future<void> _showItemInputDialog(BuildContext context, var data) async {
    TextEditingController quantityController = TextEditingController(text: '1');
    TextEditingController unitController = TextEditingController();
    TextEditingController rateController =
        TextEditingController(text: data['basic_value']);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'Update Item',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  data['item_name'],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 115,
                    child: TextBox(
                        helpText: 'Quantity',
                        controller: quantityController,
                        textInputType: TextInputType.number),
                  ),
                  SizedBox(
                      width: 115,
                      child: Dropdown(
                        helpText: 'unit',
                        defaultValue: '-',
                      )),
                ],
              ),
              TextBox(
                  helpText: 'Rate',
                  controller: rateController,
                  textInputType: TextInputType.number),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // You can handle the form data here
                String quantity = quantityController.text;
                String unit = unitController.text;
                String rate = rateController.text;

                print('Quantity: $quantity, Unit: $unit, Rate: $rate');

                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
