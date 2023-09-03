import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_state.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../CommonWidgets/Button.dart';
import '../../CommonWidgets/CustomSnackbar.dart';
import '../../CommonWidgets/DropDown.dart';
import '../../CommonWidgets/productTable.dart';
import '../../CommonWidgets/searchBox.dart';
import '../Blocs/Invoice/invoice_event.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InvoiceFormState();
  }
}

class _InvoiceFormState extends State<Invoice> {
  CustomSnackbar showMsg = CustomSnackbar();
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

  double calculateQuantity(dynamic qty, String unit, dynamic rate) {
    double stk = 0;
    qty = double.parse(qty);
    rate = double.parse(rate);

    if (unit == 'gm' || unit == 'ml') {
      stk = qty / 1000;
    }
    if (unit == 'kg' ||
        unit == 'ltr' ||
        unit == 'btl' ||
        unit == 'pkt' ||
        unit == 'pcs' ||
        unit == 'pouch' ||
        unit == 'hgr') {
      stk = qty / 1;
    }
    if (unit == 'qtl') {
      stk = qty * 100;
    }
    double value = stk * rate;
    return value;
  }

  final List<Map<String, String>> _columnList = [
    {'title': 'item Number', 'key': 'item_id', 'width': '220.0'},
    {'title': 'item Name', 'key': 'item_name', 'width': '400.0'},
    {'title': 'HSN No', 'key': 'item_hsn', 'width': '250.0'},
    {'title': 'UNIT', 'key': 'item_unit', 'width': '250.0'},
    {'title': 'GST', 'key': 'item_gst', 'width': '225.0'},
    {'title': 'Rate', 'key': 'item_rate', 'width': '210.0'},
    {'title': 'Value', 'key': 'item_value', 'width': '215.0'},
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      var id = _itemIdController.text;
      Map<String, dynamic>? result;
      if (BlocProvider.of<ItemmasterBloc>(context).state is StoreListState) {
        final state =
            BlocProvider.of<ItemmasterBloc>(context).state as StoreListState;
        result = state.dataList.firstWhere(
          (map) => map['item_id'] == id,
          orElse: () => null, // Return null if no match is found
        );
      }

      if (result != null) {
        // When the focus leaves the TextField, print a message
        print("Focus left TextField: ${result['item_unit']}");
        _itemIdController.text = result['item_id'];
        _itemNameController.text = result['item_name'];
        _itemHsnController.text = result['item_hsn'];
        _itemQtyController.text = "1";
        _itemUnitController.text = result['item_unit'];
        _itemGstController.text = result['item_gst'];
        _itemRateController.text = result['basic_value'];
        _itemvalueController.text = result['basic_value'];
        setState(() {
          condition = true;
        });
      } else {
        // Handle the case where no match was found
        print("Focus left TextField: No matching item found for ID: $id");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (state is ErrorInvoiceState) {
            if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(showMsg.showSnackbar(
                  Colors.amber, Colors.black, state.errorMessage));
            }
          }
        },
        child: SizedBox(
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
                              bottom:
                                  BorderSide(width: 1, color: Colors.black))),
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
                        margin: const EdgeInsets.all(8),
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
                                            onChange: (val) {
                                              BlocProvider.of<InvoiceBloc>(
                                                      context)
                                                  .add(CustomerDetailEvent(
                                                      _customerName.text,
                                                      _customerNumber.text,
                                                      _customerAddress.text));
                                            },
                                          ),
                                        ),
                                        Flexible(
                                            child: TextBox(
                                          helpText: "Customer Number",
                                          controller: _customerNumber,
                                          onChange: (val) {
                                            BlocProvider.of<InvoiceBloc>(
                                                    context)
                                                .add(CustomerDetailEvent(
                                                    _customerName.text,
                                                    _customerNumber.text,
                                                    _customerAddress.text));
                                          },
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
                                          onChange: (val) {
                                            BlocProvider.of<InvoiceBloc>(
                                                    context)
                                                .add(CustomerDetailEvent(
                                                    _customerName.text,
                                                    _customerNumber.text,
                                                    _customerAddress.text));
                                          },
                                        ))
                                      ])
                                ],
                              );
                            },
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
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                    child: SizedBox(
                                        width: 150,
                                        child: TextBox(
                                          controller: _itemIdController,
                                          helpText: "Item Number",
                                          focusNode: _focusNode,
                                        ))),
                                SizedBox(
                                    width: 450,
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
                                          condition =
                                              selection?.item_id?.isNotEmpty
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
                                                    _itemUnitController.text,
                                                    _itemRateController.text)
                                                .toString();
                                      },
                                    )),
                                SizedBox(
                                    width: 150,
                                    child: Dropdown(
                                      helpText: "Unit",
                                      defaultValue: _itemUnitController.text,
                                      onChange: (value) {
                                        _itemUnitController.text = value;
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
                                    )),
                                BlocBuilder<InvoiceBloc, InvoiceState>(
                                  builder: (context, state) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                            width: 150,
                                            child: Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 20, 0, 0),
                                                child: Button(
                                                  onPress: () {
                                                    BlocProvider.of<
                                                                InvoiceBloc>(
                                                            context)
                                                        .add(AddItemEvent(
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
                                                  },
                                                  btnColor: Colors.green,
                                                  textColor: Colors.white,
                                                  btnText: 'Add',
                                                ))),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(
                                    width: 200,
                                    child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            15, 20, 0, 0),
                                        child: Button(
                                          onPress: () {
                                            showDeleteConfirmationDialog(
                                                context, "Delete", () {
                                              BlocProvider.of<InvoiceBloc>(
                                                      context)
                                                  .add(DeleteItemEvent(
                                                      _itemIdController.text));
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
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue.shade100),
                      margin: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: BlocBuilder<InvoiceBloc, InvoiceState>(
                          builder: (context, state) {
                            if (state is InvoiceItemListState) {
                              return ProductTable(
                                columnList: _columnList,
                                dataList: state.dataList,
                                onTab: (value) {
                                  print(value);
                                },
                              );
                            } else {
                              return ProductTable(
                                columnList: _columnList,
                                dataList: const [],
                              );
                            }
                          },
                        ),
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
                      child: BlocListener<InvoiceBloc, InvoiceState>(
                        listener: (context, state) {
                          late double tot = 0;
                          // TODO: implement listener
                          if (state is InvoiceItemListState) {
                            for (var product in state.dataList) {
                              tot += double.parse(product['item_value']);
                            }
                            setState(() {
                              totalItem = state.dataList.length;
                              totalItemValue = tot;
                            });
                          }
                          if (state is InvoiceStatus) {
                            if (state.status == "save") {
                              showAboutDialog(
                                context: context,
                                applicationName: state.status,
                                applicationVersion: state.status,
                              );
                            } else {
                              Common cm = Common();
                              cm.showPrintPreview(context);
                            }
                            clearCustField();
                            clearFields();
                            setState(() {
                              totalItem = 0;
                              totalItemValue = 0;
                            });
                          }
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 400,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Total Items: ', // Replace with your actual amount
                                        style: TextStyle(
                                          fontSize: 24,
                                          letterSpacing: 3,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 162, 55, 28),
                                        ),
                                      ),
                                      Text(
                                        totalItem.toString(),
                                        style: const TextStyle(
                                            letterSpacing: 3,
                                            color: Color.fromARGB(
                                                255, 162, 55, 28),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 400,
                                ),
                                const SizedBox(
                                  width: 400,
                                ),
                                SizedBox(
                                  width: 400,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Total Amount: ', // Replace with your actual amount
                                        style: TextStyle(
                                          fontSize: 24,
                                          letterSpacing: 3,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 162, 55, 28),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.currency_rupee_rounded,
                                        color: Color.fromARGB(255, 162, 55, 28),
                                      ),
                                      Text(
                                        totalItemValue.toString(),
                                        style: const TextStyle(
                                            letterSpacing: 3,
                                            color: Color.fromARGB(
                                                255, 162, 55, 28),
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      )),
                ),
                SizedBox(
                  height: 75,
                  width: double.infinity,
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.blue.shade100),
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width: 150,
                                  margin: const EdgeInsets.all(10),
                                  child: Button(
                                    onPress: () {
                                      if (totalItem > 0) {
                                        BlocProvider.of<InvoiceBloc>(context)
                                            .add(PrintBill(
                                                _customerName.text,
                                                _customerNumber.text,
                                                _customerAddress.text,
                                                "Save"));
                                      } else {
                                        showAlertDialog(
                                            context, "Insert item...");
                                      }
                                    },
                                    btnColor: Colors.green,
                                    textColor: Colors.white,
                                    btnText: 'Save',
                                  )),
                              SizedBox(
                                width: 150,
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Button(
                                      onPress: () {
                                        // showAboutDialog(
                                        //   context: context,
                                        //   applicationName: 'MenuBar Sample',
                                        //   applicationVersion: '1.0.0',
                                        // );
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             PrintScreen()));
                                        // Common cm = Common();
                                        // cm.showPrintPreview(context);
                                        BlocProvider.of<InvoiceBloc>(context)
                                            .add(PrintBill(
                                                _customerName.text,
                                                _customerNumber.text,
                                                _customerAddress.text,
                                                "print"));
                                      },
                                      btnColor: Colors.orange,
                                      textColor: Colors.white,
                                      btnText: 'Print',
                                    )),
                              ),
                              SizedBox(
                                width: 150,
                                child: Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Button(
                                      onPress: () {
                                        // showAboutDialog(
                                        //   context: context,
                                        //   applicationName: 'MenuBar Sample',
                                        //   applicationVersion: '1.0.0',
                                        // );
                                        showDeleteConfirmationDialog(
                                            context, "Cancel", () {
                                          BlocProvider.of<InvoiceBloc>(context)
                                              .add(CancelBill());
                                        });
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
      ),
    );
  }
}
