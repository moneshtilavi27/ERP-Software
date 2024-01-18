import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/Music/musicPlayer.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:erp/mobile_screen/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class SearchItemMaster extends SearchDelegate<String> {
  List<dynamic> products;
  final String userType;
  late String selectedResult;
  SearchItemMaster(this.products, this.userType);
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();

  String? itemvalidation(String? value) {
    if (value == null || value.isEmpty || value == '0') {
      return 'Empty Field...';
    }
    return null;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // In the buildResults method, you should display the selected item based on user interaction.
    // You can access the selected item using `selectedResult`.
    // For example, if `selectedResult` is an index of the selected item, you can do the following:

    if (selectedResult.isNotEmpty) {
      // Access the selected item based on the index or any other identifier.
      var selectedItem = products[int.parse(selectedResult)];

      return Center(
        child: Column(
          children: [
            Text(selectedItem['item_name']),
            // Display other details of the selected item.
          ],
        ),
      );
    } else {
      // Handle the case when no item is selected.
      return Center(
        child: Text("No item selected"),
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<dynamic> suggestedUser = [];
    query.isEmpty
        ? suggestedUser = products
        : suggestedUser.addAll(products.where(
            (element) =>
                element['item_name']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                element['item_hsn']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
          ));

    return ListView.builder(
      itemCount: suggestedUser.length,
      itemBuilder: (context, index) => Column(
        children: [
          ListTile(
            title: Text(
              suggestedUser[index]['item_name'],
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(suggestedUser[index]['item_hsn'],
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
                  suggestedUser[index]['basic_value'] +
                      " / " +
                      suggestedUser[index]['item_unit'],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 162, 55, 28),
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            onTap: () {
              if (userType == "admin") {
                _showItemInputDialog(context, suggestedUser[index]);
              } else {
                Fluttertoast.showToast(
                  msg: "You Dont Have Permission to add Item",
                );
              }
            },
            onLongPress: () {
              if (userType == "admin") {
                showDeleteConfirmationDialog(context, "Delete", () {
                  BlocProvider.of<ItemmasterBloc>(context).add(DeleteItemEvent(
                      suggestedUser[index]['item_id'].toString()));
                });
              } else {
                Fluttertoast.showToast(
                  msg: "You Dont Have Permission to add Item",
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
  }

  Future<void> _showItemInputDialog(BuildContext context, var data) async {
    bool condition = data!['item_id'] == null ? true : false;
    String heading = condition ? 'Add' : 'Update';
    TextEditingController _barcodeController =
        TextEditingController(text: data!['barcode'] ?? '');
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
    late var res;
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
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextBox(
                    helpText: 'Barcode Id',
                    controller: _barcodeController,
                    suffixIcon: Icons.qr_code_scanner_sharp,
                    suffixClick: () async => {
                      res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SimpleBarcodeScannerPage(),
                          )),
                      if (res != '-1')
                        {
                          MusicPlayer.playMusic("success"),
                          _barcodeController.text = res
                        }
                    },
                  ),
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
                            textInputType: TextInputType.number),
                      ),
                      SizedBox(
                        width: 115,
                        child: Dropdown(
                          helpText: 'unit',
                          defaultValue: _itemUnitController.text,
                          onChange: (value) {
                            _itemUnitController.text = value.toString();
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
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButtonStyle.greenButtonStyle,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  try {
                    BlocProvider.of<ItemmasterBloc>(context).add(condition
                        ? AddItemEvent(
                            _barcodeController.text,
                            _itemNameController.text,
                            _itemHsnController.text,
                            _itemGstController.text,
                            _itemUnitController.text,
                            _itemMrpController.text,
                            _itemvalueController.text)
                        : UpdateItemEvent(
                            data['item_id'].toString(),
                            _barcodeController.text,
                            _itemNameController.text,
                            _itemHsnController.text,
                            _itemGstController.text,
                            _itemUnitController.text,
                            _itemMrpController.text,
                            _itemvalueController.text));
                    data!['barcode'] = _barcodeController.text;
                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: Text(heading),
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
