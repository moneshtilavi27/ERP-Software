
import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
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
  var isLoading = false;

  @override
  void initState() {
    super.initState();

    loadData();
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
    TextEditingController unitController = TextEditingController();
    TextEditingController rateController =
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 115,
                    child: TextBox(
                        helpText: 'Quantity',
                        controller: quantityController,
                        textInputType: TextInputType.number),
                  ),
                  SizedBox(
                      width: 115,
                      child: Dropdown(
                        helpText: 'unit',
                        defaultValue: '-',
                      )),
                ],
              ),
              TextBox(
                  helpText: 'Rate',
                  controller: rateController,
                  textInputType: TextInputType.number),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // You can handle the form data here
                String quantity = quantityController.text;
                String unit = unitController.text;
                String rate = rateController.text;

                print('Quantity: $quantity, Unit: $unit, Rate: $rate');

                Navigator.pop(context);
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
    TextEditingController newrateController = TextEditingController();

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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextBox(
                  helpText: 'Old Rate',
                  prefixIcon: Icons.currency_rupee,
                  controller: oldrateController,
                  enabled: false,
                  textInputType: TextInputType.number),
              TextBox(
                  helpText: 'New Rate',
                  prefixIcon: Icons.currency_rupee,
                  controller: newrateController,
                  textInputType: TextInputType.number),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // You can handle the form data here
                String oldRate = oldrateController.text;
                String newRate = newrateController.text;

                print('Quantity: $oldRate, Rate: $newRate');

                Navigator.pop(context);
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
