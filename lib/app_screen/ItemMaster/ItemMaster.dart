import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Internet/internet_bloc.dart';
import 'package:erp/Blocs/Internet/internet_state.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../CommonWidgets/Button.dart';
import '../../CommonWidgets/DropDown.dart';
import '../../CommonWidgets/productTable.dart';
import '../../CommonWidgets/searchBox.dart';
import '../../Blocs/Item Mater/itemmaster_event.dart';

class ItemMaster extends StatefulWidget {
  const ItemMaster({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ItemMasterFormState();
  }
}

class _ItemMasterFormState extends State<ItemMaster> {
  late final TextEditingController _itemIdController = TextEditingController();
  late TextEditingController _itemNameController = TextEditingController();
  late final TextEditingController _itemHsnController = TextEditingController();
  late final TextEditingController _itemUnitController =
      TextEditingController(text: "-");
  late final TextEditingController _itemGstController = TextEditingController();
  late final TextEditingController _itemvalueController =
      TextEditingController();
  String itemUnit = "";
  bool condition = true;

  final List<Map<String, String>> _columnList = [
    {'title': 'item Number', 'key': 'item_id', 'width': '220.0'},
    {'title': 'item Name', 'key': 'item_name', 'width': '400.0'},
    {'title': 'HSN No', 'key': 'item_hsn', 'width': '250.0'},
    {'title': 'UNIT', 'key': 'item_unit', 'width': '250.0'},
    {'title': 'GST', 'key': 'item_gst', 'width': '225.0'},
    {'title': 'Rate', 'key': 'basic_value', 'width': '210.0'},
    {'title': 'Value', 'key': 'whole_sale_value', 'width': '215.0'},
  ];

  clearFields() {
    _itemIdController.text = "";
    _itemNameController.text = "";
    _itemHsnController.text = "";
    _itemUnitController.text = "-";
    _itemGstController.text = "";
    _itemvalueController.text = "";
  }

  @override
  void initState() {
    super.initState();
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
                  "Item Master",
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
                              width: 450,
                              child: Container(
                                  child: SearchBox(
                                helpText: "Item Name",
                                onSelected: (dynamic selection) {
                                  _itemIdController.text = selection?.item_id;
                                  _itemNameController.text =
                                      selection?.item_name;
                                  _itemHsnController.text = selection?.item_hsn;
                                  _itemUnitController.text =
                                      selection?.item_unit;
                                  _itemGstController.text = selection?.item_gst;
                                  _itemvalueController.text =
                                      selection?.basic_value;
                                  print(selection?.item_id);
                                  setState(() {
                                    condition = selection?.item_id?.isNotEmpty
                                        ? false
                                        : true;
                                  });
                                },
                                onFocuseOut: (cotroller) {
                                  _itemNameController = cotroller;
                                },
                                onChange: (val) {
                                  setState(() {
                                    condition = true;
                                  });
                                },
                                controller: _itemNameController,
                                listWidth: 430,
                              ))),
                          SizedBox(
                              width: 150,
                              child: Container(
                                  child: TextBox(
                                helpText: "HSN No",
                                controller: _itemHsnController,
                              ))),
                          SizedBox(
                              width: 150,
                              child: Container(
                                  child: TextBox(
                                helpText: "GST",
                                controller: _itemGstController,
                              ))),
                          SizedBox(
                              width: 150,
                              child: Container(
                                  child: Dropdown(
                                helpText: "Unit",
                                defaultValue: _itemUnitController.text,
                                onChange: (value) {
                                  _itemUnitController.text = value;
                                  setState(() {
                                    itemUnit = value;
                                  });
                                },
                              ))),
                          SizedBox(
                              width: 150,
                              child: Container(
                                  child: TextBox(
                                helpText: "Rate",
                                controller: _itemvalueController,
                              ))),
                          BlocBuilder<ItemmasterBloc, ItemmasterState>(
                            builder: (context, state) {
                              return SizedBox(
                                  width: 200,
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 20, 0, 0),
                                      child: Button(
                                        onPress: () {
                                          condition
                                              ? BlocProvider.of<ItemmasterBloc>(
                                                      context)
                                                  .add(AddItemEvent(
                                                      _itemNameController.text,
                                                      _itemHsnController.text,
                                                      _itemGstController.text,
                                                      _itemUnitController.text,
                                                      _itemvalueController.text,
                                                      _itemvalueController
                                                          .text))
                                              : BlocProvider.of<ItemmasterBloc>(
                                                      context)
                                                  .add(UpdateItemEvent(
                                                      _itemIdController.text,
                                                      _itemNameController.text,
                                                      _itemHsnController.text,
                                                      _itemGstController.text,
                                                      _itemUnitController.text,
                                                      _itemvalueController.text,
                                                      _itemvalueController
                                                          .text));
                                          clearFields();
                                        },
                                        btnColor: condition
                                            ? Colors.green
                                            : Colors.blue.shade300,
                                        textColor: Colors.white,
                                        btnText: condition ? 'Add' : 'Update',
                                      )));
                            },
                          ),
                          SizedBox(
                              width: 200,
                              child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 20, 0, 0),
                                  child: Button(
                                    onPress: () {
                                      showDeleteConfirmationDialog(
                                          context, "Delete", () {
                                        BlocProvider.of<ItemmasterBloc>(context)
                                            .add(DeleteItemEvent(
                                                _itemIdController
                                                    .text)); // Close the dialog
                                      });
                                      clearFields();
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
                    child: BlocBuilder<ItemmasterBloc, ItemmasterState>(
                      builder: (context, state) {
                        if (state is StoreListState) {
                          return ProductTable(
                            columnList: _columnList,
                            dataList: state.dataList,
                            onTab: (value) {},
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
          ],
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
      ),
    );
  }
}
