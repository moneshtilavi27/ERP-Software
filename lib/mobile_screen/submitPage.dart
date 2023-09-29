import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_bloc.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_state.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_event.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_state.dart';
import 'package:erp/mobile_screen/app_drawer.dart';
import 'package:erp/mobile_screen/home.dart';
import 'package:erp/mobile_screen/printOptionDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CommonWidgets/Button.dart';

class SubmitScreen extends StatefulWidget {
  final String title;

  const SubmitScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _submitScreenState();
}

class _submitScreenState extends State<SubmitScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _custName = TextEditingController();
  TextEditingController _custNum = TextEditingController();
  TextEditingController _custAdd = TextEditingController();
  TextEditingController _totalItem = TextEditingController();
  TextEditingController _totalAmt = TextEditingController();
  TextEditingController _gst = TextEditingController();
  TextEditingController _discount = TextEditingController();

  int totalItems = 5; // Replace with actual total items
  double totalAmount = 0; // Replace with actual total amount
  double gst = 18; // Replace with actual GST percentage
  double discount = 0;
  double fontSize = 12;
  int totalItem = 0;
  double gstAmount = 0;
  double totalItemValue = 0;

  String? _validateCustomername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Customer Name.';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a mobile number.';
    }
    final mobileNumberRegex = r'^[0-9]{10}$';

    if (!RegExp(mobileNumberRegex).hasMatch(value)) {
      return 'Please enter a valid mobile number.';
    }
    return null;
  }

  dynamic jsonData;

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
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: BlocConsumer<InvoiceBloc, InvoiceState>(
                listener: (context, state) {
              if (state is InvoiceDataState) {
                if (state.status == "save") {
                  showAboutDialog(
                    context: context,
                    applicationName: state.status,
                    applicationVersion: state.status,
                  );
                } else {
                  Common cm = Common();
                  cm
                      .showPrintPreview(
                          context, state.dataList, state.status, true)
                      .then((value) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const AppDrawer(title: "Invoice"),
                      ),
                      (route) => false, // Clear all routes from the stack.
                    );
                  });
                }
                setState(() {
                  totalItem = 0;
                  totalItemValue = 0;
                });
              }
            }, builder: (context, state) {
              late double tot = 0;
              late double value = 0;
              late double gstPercentage = 0;
              late double gstAmount = 0;
              if (state is InvoiceItemListState) {
                _totalItem.text = state.dataList.length.toString();
                for (var product in state.dataList) {
                  tot += double.parse(product['item_value']);

                  value = (product['item_value'] != null &&
                          product['item_value'].isNotEmpty)
                      ? double.tryParse(product['item_value']) ?? 0
                      : 0;
                  gstPercentage = (product['item_gst'] != null &&
                          product['item_gst'].isNotEmpty)
                      ? double.tryParse(product['item_gst']) ?? 0
                      : 0;

                  gstAmount += ((value * gstPercentage) / 100) / 2;
                }
                _totalAmt.text = tot.toString();
                if (totalAmount == 0) {
                  totalAmount = tot;
                }
                _gst.text = gstAmount.toString();

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: TextBox(
                            helpText: "Customer Name",
                            controller: _custName,
                            validator: _validateCustomername,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: TextBox(
                            helpText: "Phone Number",
                            controller: _custNum,
                            validator: _validateMobileNumber,
                            textInputType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: TextBox(
                            helpText: "Adress",
                            controller: _custAdd,
                            textInputType: TextInputType.multiline,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 5),
                        billTiles(
                          "Total Items",
                          controller: _totalItem,
                          enable: false,
                        ),
                        const Divider(height: 5),
                        billTiles(
                          "Total Amount:",
                          controller: _totalAmt,
                          enable: false,
                        ),
                        const Divider(height: 5),
                        billTiles(
                          "CGST",
                          controller: _gst,
                          enable: false,
                        ),
                        const Divider(height: 5),
                        billTiles(
                          "SGST",
                          controller: _gst,
                          enable: false,
                        ),
                        const Divider(height: 5),
                        billTiles("Discount",
                            controller: _discount,
                            enable: true, onChange: (value) {
                          double v = (value != null && value.isNotEmpty)
                              ? double.tryParse(value) ?? 0
                              : 0;
                          setState(() {
                            totalAmount = tot - v;
                          });
                        }),
                        const Divider(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: ListTile(
                            leading: const Text(
                              "Net Amount",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.only(right: 35),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.currency_rupee_rounded),
                                  Text(
                                    totalAmount.toString(),
                                    style: const TextStyle(
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
                                  if (_formKey.currentState!.validate()) {
                                    if (tot > 0) {
                                      showPrintDialog(
                                          context,
                                          _custName.text,
                                          _custNum.text,
                                          _custAdd.text,
                                          _discount.text);
                                    } else {
                                      showAlertDialog(
                                          context, "Insert item...");
                                    }
                                  }
                                },
                                btnColor: Colors.orange,
                                textColor: Colors.white,
                                btnText: 'Print / Save',
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
          ),
        ),
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
}

class billTiles extends StatelessWidget {
  final String textTitle;
  final bool enable;
  final TextEditingController controller;
  final double fontSize = 12;
  final Function? onChange;
  const billTiles(this.textTitle,
      {super.key,
      required this.controller,
      required this.enable,
      this.onChange});

  @override
  Widget build(
    BuildContext context,
  ) {
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
              enabled: enable,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                hintText: "0.0",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onChanged: onChange != null
                  ? ((value) => {onChange!(value)})
                  : (value) => {},
            ),
          ),
        ],
      ),
    );
  }
}
