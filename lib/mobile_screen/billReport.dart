import 'package:erp/CommonWidgets/DropDown.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/Blocs/Invoice/invoice_state.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_event.dart';
import 'package:erp/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/Constants/Colors.dart';
import 'package:erp/mobile_screen/invoice.dart';
import 'package:erp/mobile_screen/reportBillPrint.dart';
import 'package:erp/mobile_screen/searchItemMaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillReport extends StatefulWidget {
  final String title;
  BillReport({Key? key, required this.title}) : super(key: key);
  //  late invoiceBloc = BlocProvider.of<InvoiceBloc>(context);
  //   invoiceBloc.add(FeatchInvoiceReportEvent());

  String dropdownValue = "";
  @override
  _ItemMasterState createState() => _ItemMasterState();
}

class _ItemMasterState extends State<BillReport> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey1 = GlobalKey();
  late InvoiceBloc invoiceBloc = BlocProvider.of<InvoiceBloc>(context);
  List DataSet = [];
  var isLoading = false;
  String itemUnit = "";

  @override
  void initState() {
    super.initState();
    invoiceBloc.add(ClearStateEvent());
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
        backgroundColor: TheamColors.theamColor,
        foregroundColor: TheamColors.white,
        // actions: [
        //   AppBarActionButton(),
        // ],
      ),
      body: BlocConsumer<InvoiceBloc, InvoiceState>(
          listener: (BuildContext context, InvoiceState state) {
        if (state is InvoiceReportState) {
          setState(() {
            DataSet = state.dataList;
          });
        }
      }, builder: (context, state) {
        if (DataSet.isNotEmpty) {
          return ListView.builder(
            itemCount: DataSet.length,
            itemBuilder: (context, index) => Column(
              children: [
                ListTile(
                  leading: Text(
                    DataSet[index]['number'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 162, 55, 28),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  title: Text(
                    DataSet[index]['customer_name'],
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  subtitle: Text(
                      DateTime.parse(DataSet[index]['created'])
                          .add(Duration(minutes: 30))
                          .toString(),
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
                                invoiceNum: DataSet[index]['number'])));
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
