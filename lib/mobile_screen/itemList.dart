import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_event.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/mobile_screen/searchItemMaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemList extends StatefulWidget {
  final String title;
  ItemList({Key? key, required this.title}) : super(key: key);

  String dropdownValue = "";
  @override
  _ItemMasterState createState() => _ItemMasterState();
}

class _ItemMasterState extends State<ItemList> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  var isLoading = false;
  String itemUnit = "";

  @override
  void initState() {
    super.initState();

    loadData();
  }

  String? itemvalidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Empty Field...';
    }
    return null;
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
        actions: [
          AppBarActionButton(),
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showItemInputDialog(context, {});
              })
        ],
      ),
      body: BlocBuilder<ItemmasterBloc, ItemmasterState>(
          builder: (context, state) {
        if (state is StoreListState) {
          return isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
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
                          _showItemInputDialog(context, state.dataList[index]);
                        },
                        onLongPress: () {},
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
    );
  }

  Future<void> _showItemInputDialog(BuildContext context, var data) async {
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
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: Text(heading),
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

class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemmasterBloc, ItemmasterState>(
        builder: (context, state) {
      if (state is StoreListState) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
                context: context, delegate: SearchItemMaster(state.dataList));
          },
        );
      } else {
        return const Text("");
      }
    });
  }
}
