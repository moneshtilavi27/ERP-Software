import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSearch extends SearchDelegate<String> {
  List<dynamic> products;
  late String selectedResult;
  UserSearch(this.products);
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
              // Handle item selection here
              // You can set the selectedResult to an index or an identifier.
              // selectedResult = index.toString();
              // showResults(context);
              _showItemInputDialog(context, suggestedUser[index]);
            },
            onLongPress: () {
              _showItemRateChangeDialog(context, index, suggestedUser[index]);
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
                    // update data in offline
                    if (index != null) {
                      // DataSet[index]["item_unit"] = newUnitController.text;
                      products[index]["basic_value"] = newrateController.text;
                      products[index]["whole_sale_value"] =
                          newrateController.text;
                    }
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
