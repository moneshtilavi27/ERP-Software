import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/Blocs/Invoice/invoice_state.dart';
import 'package:erp/CommonWidgets/Button.dart';
import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/CommonWidgets/searchBox.dart';
import 'package:erp/Constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Winvoice extends StatefulWidget {
  const Winvoice({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WInvoiceFormState();
  }
}

class _WInvoiceFormState extends State<Winvoice> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final TextEditingController _customerName = TextEditingController();
  late final TextEditingController _customerNumber = TextEditingController();
  late final TextEditingController _customerAddress = TextEditingController();

  late final TextEditingController _itemIdController = TextEditingController();
  late TextEditingController _itemNameController = TextEditingController();
  late final TextEditingController _itemHsnController = TextEditingController();
  late final TextEditingController _itemUnitController =
      TextEditingController(text: "-");
  late final TextEditingController _itemQtyController =
      TextEditingController(text: "1");
  late final TextEditingController _itemGstController = TextEditingController();
  late final TextEditingController _itemvalueController =
      TextEditingController();
  late final TextEditingController _itemRateController =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();

  String itemUnit = "";
  bool condition = true;
  String name = "";
  int totalItem = 0;
  double totalItemValue = 0;

  clearFields() {
    _itemIdController.text = "";
    _itemNameController.text = "";
    _itemHsnController.text = "";
    _itemUnitController.text = "-";
    _itemQtyController.text = "";
    _itemGstController.text = "";
    _itemvalueController.text = "";
    _itemRateController.text = "";
  }

  clearCustField() {
    _customerName.text = "";
    _customerNumber.text = "";
    _customerAddress.text = "";
  }

  String? _validateCustomername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Customer Name.';
    }
    return null;
  }

  String? _itemId(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a Item Id.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: SizedBox(
                child: Container(
                    margin: const EdgeInsets.all(0.0),
                    decoration: BoxDecoration(color: TheamColors.bodyColor),
                    child: Column(children: [
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black))),
                            child: const Text(
                              "Invoice",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25),
                            )),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              width: 700,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.transparent),
                                  child: BlocBuilder<InvoiceBloc, InvoiceState>(
                                    builder: (context, state) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Flexible(
                                                  child: TextBox(
                                                    helpText: "Customer Name",
                                                    controller: _customerName,
                                                    validator:
                                                        _validateCustomername,
                                                  ),
                                                ),
                                                Flexible(
                                                    child: TextBox(
                                                  helpText: "Customer Number",
                                                  controller: _customerNumber,
                                                  validator:
                                                      _validateMobileNumber,
                                                )),
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Flexible(
                                                    child: TextBox(
                                                  helpText: "Customer Address",
                                                  controller: _customerAddress,
                                                ))
                                              ])
                                        ],
                                      );
                                    },
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.transparent),
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 1),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                            child: SizedBox(
                                                width: 150,
                                                child: TextBox(
                                                  controller: _itemIdController,
                                                  helpText: "Item Number",
                                                  enabled: false,
                                                  focusNode: _focusNode,
                                                ))),
                                        SizedBox(
                                            width: 420,
                                            child: SearchBox(
                                              helpText: "Item Name",
                                              onSelected: (dynamic selection,
                                                  dynamic cotroller) {
                                                _itemNameController = cotroller;
                                                _itemIdController.text =
                                                    selection?.item_id;
                                                _itemNameController.text =
                                                    selection?.item_name;
                                                _itemHsnController.text =
                                                    selection?.item_hsn;
                                                _itemQtyController.text = "1";
                                                _itemUnitController.text =
                                                    selection?.item_unit;
                                                _itemGstController.text =
                                                    selection?.item_gst;
                                                _itemRateController.text =
                                                    selection?.basic_value;
                                                _itemvalueController.text =
                                                    selection?.basic_value;
                                                setState(() {
                                                  condition = selection
                                                          ?.item_id?.isNotEmpty
                                                      ? false
                                                      : true;
                                                });
                                              },
                                              onChange: (val) {
                                                setState(() {
                                                  condition = true;
                                                });
                                              },
                                              onFocuseOut: (cotroller) {
                                                _itemNameController = cotroller;
                                              },
                                              controller: _itemNameController,
                                              listWidth: 430,
                                            )),
                                        SizedBox(
                                            width: 150,
                                            child: TextBox(
                                              enabled: false,
                                              helpText: "HSN No",
                                              controller: _itemHsnController,
                                            )),
                                        SizedBox(
                                            width: 150,
                                            child: TextBox(
                                              helpText: "Quantity",
                                              controller: _itemQtyController,
                                              onChange: (val) {
                                                _itemvalueController.text =
                                                    calculateQuantity(
                                                            val,
                                                            _itemUnitController
                                                                .text,
                                                            _itemRateController
                                                                .text)
                                                        .toString();
                                              },
                                            )),
                                        SizedBox(
                                            width: 150,
                                            child: Dropdown(
                                              helpText: "Unit",
                                              defaultValue:
                                                  _itemUnitController.text,
                                              onChange: (value) {
                                                _itemUnitController.text =
                                                    value;
                                                setState(() {
                                                  itemUnit = value;
                                                });
                                              },
                                            )),
                                        SizedBox(
                                            width: 150,
                                            child: TextBox(
                                              helpText: "Rate",
                                              controller: _itemRateController,
                                            )),
                                        SizedBox(
                                            width: 150,
                                            child: TextBox(
                                              helpText: "Value",
                                              controller: _itemvalueController,
                                              enabled: false,
                                            )),
                                        BlocBuilder<InvoiceBloc, InvoiceState>(
                                          builder: (context, state) {
                                            return Row(
                                              children: [
                                                SizedBox(
                                                    width: 150,
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                            .fromLTRB(
                                                            10, 20, 0, 0),
                                                        child: Button(
                                                          onPress: () {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              BlocProvider.of<InvoiceBloc>(context).add(AddProductEvent(
                                                                  _itemIdController
                                                                      .text,
                                                                  _itemNameController
                                                                      .text,
                                                                  _itemHsnController
                                                                      .text,
                                                                  _itemGstController
                                                                      .text,
                                                                  _itemQtyController
                                                                      .text,
                                                                  _itemUnitController
                                                                      .text,
                                                                  _itemRateController
                                                                      .text,
                                                                  _itemvalueController
                                                                      .text));
                                                              clearFields();
                                                            }
                                                          },
                                                          btnColor:
                                                              Colors.green,
                                                          textColor:
                                                              Colors.white,
                                                          btnText: 'Add',
                                                        ))),
                                              ],
                                            );
                                          },
                                        ),
                                        SizedBox(
                                            width: 150,
                                            child: Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 20, 0, 0),
                                                child: Button(
                                                  onPress: () {
                                                    showDeleteConfirmationDialog(
                                                        context, "Delete", () {
                                                      BlocProvider.of<
                                                                  InvoiceBloc>(
                                                              context)
                                                          .add(DeleteItemEvent(
                                                              _itemIdController
                                                                  .text));
                                                      clearFields();
                                                    });
                                                  },
                                                  btnColor: Colors.red,
                                                  textColor: Colors.white,
                                                  btnText: 'Delete',
                                                ))),
                                      ]),
                                ],
                              )),
                        ),
                      ),
                    ])))));
  }
}
