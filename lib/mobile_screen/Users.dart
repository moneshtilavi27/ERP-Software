import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_event.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Users extends StatefulWidget {
  Users({Key? key}) : super(key: key);
  String dropdownValue = "";
  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
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
    if (value == null || value.isEmpty || value == '0') {
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
    return BlocBuilder<ItemmasterBloc, ItemmasterState>(
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
                      onLongPress: () {
                        _showItemRateChangeDialog(
                            context, state.dataList[index]);
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
    });
  }

  Future<void> _showItemInputDialog(BuildContext context, var data) async {
    TextEditingController quantityController = TextEditingController(text: '1');
    TextEditingController _itemUnitController =
        TextEditingController(text: data['item_unit']);
    TextEditingController _itemvalueController =
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
                  'Add Item',
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
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 115,
                        child: TextBox(
                            helpText: 'Quantity',
                            controller: quantityController,
                            textInputType: TextInputType.number,
                            validator: itemvalidation,
                            onChange: (val) {
                              _itemvalueController.text = calculateQuantity(
                                      val,
                                      _itemUnitController.text,
                                      data['basic_value'])
                                  .toString();
                            })),
                    SizedBox(
                        width: 115,
                        child: Dropdown(
                          helpText: 'unit',
                          defaultValue: _itemUnitController.text,
                          onChange: (value) {
                            _itemUnitController.text = value.toString();
                            _itemvalueController.text = calculateQuantity(
                                    quantityController.text,
                                    _itemUnitController.text,
                                    data['basic_value'])
                                .toString();
                            setState(() {
                              itemUnit = value;
                            });
                          },
                        )),
                  ],
                ),
                TextBox(
                    enabled: false,
                    helpText: 'Value',
                    controller: _itemvalueController,
                    validator: itemvalidation,
                    textInputType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  try {
                    BlocProvider.of<InvoiceBloc>(context).add(AddProductEvent(
                        data['item_id'].toString(),
                        data['item_name'].toString(),
                        data['item_hsn'].toString(),
                        data['item_gst'].toString(),
                        quantityController.text,
                        _itemUnitController.text,
                        data['basic_value'].toString(),
                        _itemvalueController.text));
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: const Text('Add'),
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

  Future<void> _showItemRateChangeDialog(BuildContext context, var data) async {
    TextEditingController oldrateController =
        TextEditingController(text: data['basic_value']);
    TextEditingController newUnitController =
        TextEditingController(text: data['item_unit']);
    TextEditingController newrateController =
        TextEditingController(text: data['basic_value']);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Form(
            key: _formKey1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Update Item Rate',
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
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBox(
                  helpText: 'Old Rate',
                  prefixIcon: Icons.currency_rupee,
                  controller: oldrateController,
                  enabled: false,
                  textInputType: TextInputType.number),
              Dropdown(
                helpText: 'unit',
                defaultValue: newUnitController.text,
                onChange: (value) {
                  newUnitController.text = value.toString();
                },
              ),
              TextBox(
                  helpText: 'New Rate',
                  prefixIcon: Icons.currency_rupee,
                  controller: newrateController,
                  validator: itemvalidation,
                  textInputType: TextInputType.number),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_formKey1.currentState!.validate()) {
                  try {
                    BlocProvider.of<ItemmasterBloc>(context).add(
                        UpdateItemEvent(
                            data['item_id'].toString(),
                            data['item_name'].toString(),
                            data['item_hsn'].toString(),
                            data['item_gst'].toString(),
                            newUnitController.text,
                            newrateController.text,
                            newrateController.text));
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
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
