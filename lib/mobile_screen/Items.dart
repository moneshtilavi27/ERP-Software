import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/mobile_screen/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Items extends StatefulWidget {
  Items({Key? key}) : super(key: key);
  String dropdownValue = "";
  @override
  State<Items> createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  late ItemmasterBloc itemBloc = BlocProvider.of<ItemmasterBloc>(context);
  var isLoading = false;
  List DataSet = [];
  String itemUnit = "";
  late SharedPreferences sp;
  late String userType = "user";

  @override
  void initState() {
    super.initState();
    itemBloc.add(LoaderEvent());
    itemBloc.add(LoadItemmasterEvent());
    loadData();
  }

  String? itemvalidation(String? value) {
    if (value == null || value.isEmpty || value == '0') {
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
    return BlocConsumer<ItemmasterBloc, ItemmasterState>(
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
                      const Icon(Icons.currency_rupee_rounded,
                          color: Colors.grey),
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
                    _showItemInputDialog(context, DataSet[index]);
                  },
                  onLongPress: () {
                    if (userType == "admin") {
                      _showItemRateChangeDialog(context, index, DataSet[index]);
                    } else {
                      Fluttertoast.showToast(
                        msg: "You Dont Have Permission to Update Item",
                      );
                    }
                  }),
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
              style: ElevatedButtonStyle.greenButtonStyle,
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
            ElevatedButton(
              style: ElevatedButtonStyle.redButtonStyle,
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

  Future<void> _showItemRateChangeDialog(
      BuildContext context, var index, var data) async {
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
              style: ElevatedButtonStyle.greenButtonStyle,
              onPressed: () {
                if (_formKey1.currentState!.validate()) {
                  try {
                    BlocProvider.of<ItemmasterBloc>(context).add(
                        UpdateItemEvent(
                            data['item_id'].toString(),
                            data['barcode'].toString(),
                            data['item_name'].toString(),
                            data['item_hsn'].toString(),
                            data['item_gst'].toString(),
                            newUnitController.text,
                            newrateController.text,
                            newrateController.text));

                    // update data in offline
                    if (index != null) {
                      setState(() {
                        DataSet[index]["item_id"] = data['item_id'].toString();
                        DataSet[index]["item_name"] =
                            data['item_name'].toString();
                        DataSet[index]["item_hsn"] =
                            data['item_hsn'].toString();
                        DataSet[index]["item_gst"] =
                            data['item_gst'].toString();
                        DataSet[index]["item_unit"] = newUnitController.text;
                        DataSet[index]["basic_value"] = newrateController.text;
                        DataSet[index]["whole_sale_value"] =
                            newrateController.text;
                      });
                    }
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              style: ElevatedButtonStyle.redButtonStyle,
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
