import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_event.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_state.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/mobile_screen/app_drawer.dart';
import 'package:erp/mobile_screen/reportBillPrint.dart';
import 'package:erp/mobile_screen/searchItemMaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class billReport extends StatefulWidget {
  final String title;
  billReport({Key? key, required this.title}) : super(key: key);
  //  late invoiceBloc = BlocProvider.of<InvoiceBloc>(context);
  //   invoiceBloc.add(FeatchInvoiceReportEvent());

  String dropdownValue = "";
  @override
  _ItemMasterState createState() => _ItemMasterState();
}

class _ItemMasterState extends State<billReport> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  late InvoiceBloc invoiceBloc = BlocProvider.of<InvoiceBloc>(context);
  var isLoading = false;
  String itemUnit = "";

  @override
  void initState() {
    super.initState();
    invoiceBloc.add(FeatchInvoiceReportEvent());
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
        // actions: [
        //   AppBarActionButton(),
        // ],
      ),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(builder: (context, state) {
        if (state is InvoiceReportState) {
          return ListView.builder(
            itemCount: state.dataList.length,
            itemBuilder: (context, index) => Column(
              children: [
                ListTile(
                  leading: Text(
                    state.dataList[index]['number'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 162, 55, 28),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  title: Text(
                    state.dataList[index]['customer_name'],
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(state.dataList[index]['created'],
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowInvoice(
                                invoiceNum: state.dataList[index]['number'])));
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
    );
  }
}
