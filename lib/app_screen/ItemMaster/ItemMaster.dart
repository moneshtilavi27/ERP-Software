import 'package:erp/CommonWidgets/CustomDataTable.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/service/asset/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../CommonWidgets/Button.dart';
import '../../CommonWidgets/DropDown.dart';
import '../../CommonWidgets/productTable.dart';
import '../../CommonWidgets/searchBox.dart';
import '../Blocs/Item Mater/itemmaster_event.dart';

class ItemMaster extends StatefulWidget {
  const ItemMaster({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ItemMasterFormState();
  }
}

class _ItemMasterFormState extends State<ItemMaster> {
  late TextEditingController _itemIdController = TextEditingController();
  late TextEditingController _itemNameController = TextEditingController();
  late TextEditingController _itemHsnController = TextEditingController();
  late TextEditingController _itemGstController = TextEditingController();
  late TextEditingController _itemvalueController = TextEditingController();
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
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                        Widget>[
                      // SizedBox(
                      //     child: Container(
                      //         width: 150,
                      //         child: TextBox(
                      //           helpText: "Item Number",
                      //         ))),
                      SizedBox(
                          width: 450,
                          child: Container(
                              child: SearchBox(
                            helpText: "Item Name",
                            onSelected: (dynamic selection) {
                              _itemIdController.text = selection?.item_id;
                              _itemNameController.text = selection?.item_name;
                              _itemHsnController.text = selection?.item_hsn;
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
                            onChange: (val) {
                              // BlocProvider.of<ItemmasterBloc>(context)
                              //     .add(FeatchItemmasterEvent(val));
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
                            onChange: (value) {
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
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Button(
                                    onPress: () {
                                      // if (condition) {
                                      //   showAboutDialog(
                                      //     context: context,
                                      //     applicationName: 'MenuBar Sample',
                                      //     applicationVersion: '1.0.0',
                                      //   );
                                      // }
                                      BlocProvider.of<ItemmasterBloc>(context)
                                          .add(AddItemEvent(
                                              _itemNameController.text,
                                              _itemHsnController.text,
                                              _itemGstController.text,
                                              itemUnit,
                                              _itemvalueController.text,
                                              _itemvalueController.text));
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
                              margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                              child: Button(
                                onPress: () {
                                  showAboutDialog(
                                    context: context,
                                    applicationName: 'MenuBar Sample',
                                    applicationVersion:
                                        _itemNameController.text,
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
                  margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.all(3.0),
                    child: BlocBuilder<ItemmasterBloc, ItemmasterState>(
                      builder: (context, state) {
                        if (state is StoreListState) {
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
                            dataList: [],
                          );
                        }
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
