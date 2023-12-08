import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/mobile_screen/searchItemMaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemList extends StatefulWidget {
  final String title;
  ItemList({Key? key, required this.title}) : super(key: key);

  String dropdownValue = "";
  @override
  _ItemMasterState createState() => _ItemMasterState();
}

class _ItemMasterState extends State<ItemList> {
  late SharedPreferences sp;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  late ItemmasterBloc itemBloc = BlocProvider.of<ItemmasterBloc>(context);
  var isLoading = false;
  List DataSet = [];
  late String userType = "user";
  String itemUnit = "";

  @override
  void initState() {
    super.initState();
    itemBloc.add(LoaderEvent());
    itemBloc.add(LoadItemmasterEvent());
    loadData();
  }

  String? itemvalidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty Field...';
    }
    return null;
  }

  loadData() async {
    sp = await SharedPreferences.getInstance();
    setState(() {
      isLoading = false;
      userType = sp.getString('user_type')!;
    });
    print(userType);
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
        actions: [AppBarActionButton(userType: userType)],
      ),
      body: BlocConsumer<ItemmasterBloc, ItemmasterState>(
          listener: (BuildContext context, ItemmasterState state) {
        if (state is StoreListState) {
          setState(() {
            DataSet = state.dataList;
          });
        }
      }, builder: (BuildContext context, ItemmasterState state) {
        if (DataSet.isNotEmpty) {
          return ListView.builder(
            itemCount: DataSet.length,
            itemBuilder: (context, index) => Column(
              children: [
                ListTile(
                  title: Text(
                    DataSet[index]['item_name'],
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(DataSet[index]['item_hsn'],
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
                        DataSet[index]['basic_value'] +
                            " / " +
                            DataSet[index]['item_unit'],
                        style: const TextStyle(
                            color: Color.fromARGB(255, 162, 55, 28),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (userType == "admin") {
                      _showItemInputDialog(context, index, DataSet[index]);
                    } else {
                      Fluttertoast.showToast(
                        msg: "You Dont Have Permission to Update Item",
                      );
                    }
                  },
                  onLongPress: () {
                    if (userType == "admin") {
                      showDeleteConfirmationDialog(context, "Delete", () {
                        BlocProvider.of<ItemmasterBloc>(context).add(
                            DeleteItemEvent(
                                DataSet[index]['item_id'].toString()));
                        setState(() {
                          DataSet.removeAt(index);
                        });
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: "You Dont Have Permission to Delete Item",
                      );
                    }
                  },
                ),
                const Divider(
                  height: 5,
                )
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // Handle the print action here
          if (userType == "admin") {
            _showItemInputDialog(context, null, {});
          } else {
            Fluttertoast.showToast(
              msg: "You Dont Have Permission to add Item",
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showItemInputDialog(
      BuildContext context, var index, var data) async {
    bool condition = data!['item_id'] == null ? true : false;
    String heading = condition ? 'Add' : 'Update';
    TextEditingController _itemNameController =
        TextEditingController(text: data!['item_name'] ?? '');
    TextEditingController _itemHsnController =
        TextEditingController(text: data!['item_hsn'] ?? '');
    TextEditingController _itemGstController =
        TextEditingController(text: data!['item_gst'] ?? '0');
    TextEditingController _itemUnitController =
        TextEditingController(text: data!['item_unit'] ?? '-');
    TextEditingController _itemMrpController =
        TextEditingController(text: data['basic_value'] ?? '0');
    TextEditingController _itemvalueController =
        TextEditingController(text: data['basic_value'] ?? '0');

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Padding(
            padding: EdgeInsets.all(3.0),
            child: Text(
              '$heading Item',
              style: TextStyle(fontSize: 20),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextBox(
                  helpText: 'Item Name',
                  controller: _itemNameController,
                  validator: itemvalidation,
                ),
                TextBox(
                    helpText: 'Item HSN',
                    controller: _itemHsnController,
                    validator: itemvalidation,
                    textInputType: TextInputType.number),
                Row(
                  children: [
                    SizedBox(
                      width: 115,
                      child: TextBox(
                          helpText: 'Item GST',
                          controller: _itemGstController,
                          validator: itemvalidation,
                          textInputType: TextInputType.number),
                    ),
                    SizedBox(
                      width: 115,
                      child: Dropdown(
                        helpText: 'unit',
                        defaultValue: _itemUnitController.text,
                        onChange: (value) {
                          _itemUnitController.text = value.toString();
                          setState(() {
                            itemUnit = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 115,
                      child: TextBox(
                          helpText: 'MRP Rate',
                          controller: _itemMrpController,
                          validator: itemvalidation,
                          textInputType: TextInputType.number),
                    ),
                    SizedBox(
                      width: 115,
                      child: TextBox(
                          helpText: 'Sale Rate',
                          controller: _itemvalueController,
                          validator: itemvalidation,
                          textInputType: TextInputType.number),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  try {
                    BlocProvider.of<ItemmasterBloc>(context).add(condition
                        ? AddItemEvent(
                            _itemNameController.text,
                            _itemHsnController.text,
                            _itemGstController.text,
                            _itemUnitController.text,
                            _itemMrpController.text,
                            _itemvalueController.text)
                        : UpdateItemEvent(
                            data['item_id'].toString(),
                            _itemNameController.text,
                            _itemHsnController.text,
                            _itemGstController.text,
                            _itemUnitController.text,
                            _itemMrpController.text,
                            _itemvalueController.text));

                    // update data in offline
                    if (index != null) {
                      setState(() {
                        DataSet[index]["item_id"] = data['item_id'].toString();
                        DataSet[index]["item_name"] = _itemNameController.text;
                        DataSet[index]["item_hsn"] = _itemHsnController.text;
                        DataSet[index]["item_gst"] = _itemGstController.text;
                        DataSet[index]["item_unit"] = _itemUnitController.text;
                        DataSet[index]["basic_value"] = _itemMrpController.text;
                        DataSet[index]["whole_sale_value"] =
                            _itemvalueController.text;
                      });
                    } else {
                      // Create a new item
                      Map<String, dynamic> newItem = {
                        "item_id": data['item_id'].toString(),
                        "item_name": _itemNameController.text,
                        "item_hsn": _itemHsnController.text,
                        "item_gst": _itemGstController.text,
                        "item_unit": _itemUnitController.text,
                        "basic_value": _itemMrpController.text,
                        "whole_sale_value": _itemvalueController.text,
                      };
                      // Add the new item to the DataSet
                      setState(() {
                        DataSet.add(newItem);
                      });
                    }

                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: Text(heading),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
              ),
            ),
          ],
        );
      },
    );
  }
}

class AppBarActionButton extends StatelessWidget {
  final String userType;
  AppBarActionButton({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemmasterBloc, ItemmasterState>(
        builder: (context, state) {
      if (state is StoreListState) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
                context: context,
                delegate: SearchItemMaster(state.dataList, userType));
          },
        );
      } else {
        return const Text("");
      }
    });
  }
}
