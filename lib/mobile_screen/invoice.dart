import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/CommonWidgets/Music/musicPlayer.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Internet/internet_bloc.dart';
import 'package:erp/Blocs/Internet/internet_state.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/Constants/Colors.dart';
import 'package:erp/mobile_screen/ItemSearch.dart';
import 'package:erp/mobile_screen/Items.dart';
import 'package:erp/mobile_screen/bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Invoice extends StatefulWidget {
  final String title;

  const Invoice({Key? key, required this.title}) : super(key: key);

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  int _selectedIndex = 0;
  late String barcodeId;
  late Widget page = Items();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        page = Items();
        break;
      case 1:
        // page = Bucket(title: "Bucket");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Bucket(title: "Bucket")));
        break;
      default:
    }
    setState(() {
      _selectedIndex = 0;
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
        backgroundColor: TheamColors.theamColor,
        foregroundColor: TheamColors.white,
        actions: const [AppBarActionButton()],
      ),
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            label: 'Invoice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bucket',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: TheamColors.theamColor,
        onTap: _onItemTapped,
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

class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({super.key});

  dynamic addItemByUsingScanner(dynamic itemId, List<dynamic> items) {
    // print(items[1]['item_id'].toString());
    final itemData = items.firstWhere(
      (item) => item['barcode'] == itemId.toString(),
      orElse: () => <String, dynamic>{},
    );
    return itemData;
  }

  Future<void> customeScannerFunction(var context, dynamic dataset) async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(
            appBarTitle: "Ono Mart",
            isShowFlashIcon: true,
            cancelButtonText: "Close",
          ),
        ));

    var itemData = (res == -1) ? -1 : addItemByUsingScanner(res, dataset);

    print(res == '-1');
    if (itemData.isEmpty) {
      if (res != '-1') {
        MusicPlayer.playMusic("error");
        Fluttertoast.showToast(
          msg: "Item not found...!",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        customeScannerFunction(context, dataset);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Bucket(title: "Bucket")));
      }
    } else {
      BlocProvider.of<InvoiceBloc>(context).add(UpdateProductEvent(
          itemData['item_id'].toString(),
          itemData['item_name'].toString(),
          itemData['item_hsn'].toString(),
          itemData['item_gst'].toString(),
          '1',
          itemData['item_unit'].toString(),
          itemData['basic_value'].toString(),
          itemData['basic_value'].toString()));
      MusicPlayer.playMusic("success");
      Fluttertoast.showToast(
        msg: itemData['item_name'] + " added successfully",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      customeScannerFunction(context, dataset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemmasterBloc, ItemmasterState>(
        builder: (context, state) {
      if (state is StoreListState) {
        return Row(children: [
          IconButton(
              icon: const Icon(Icons.qr_code_scanner_sharp),
              onPressed: () {
                customeScannerFunction(context, state.dataList);
              }),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context, delegate: ItemSearch(state.dataList));
            },
          )
        ]);
      } else {
        return const Text("");
      }
    });
  }
}
