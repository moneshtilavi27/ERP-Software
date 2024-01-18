import 'package:erp/CommonWidgets/common.dart';
import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/Blocs/Invoice/invoice_state.dart';
import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/mobile_screen/invoice.dart';
import 'package:erp/mobile_screen/billReport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showPrintDialog(
    BuildContext context, custName, custNum, custAdd, discount) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CustomAlertDialog(custName, custNum, custAdd, discount);
    },
  );
}

class CustomAlertDialog extends StatelessWidget {
  String custName, custNum, custAdd, discount;

  CustomAlertDialog(this.custName, this.custNum, this.custAdd, this.discount,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Options'),
      content: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoading) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOptionButton(context, 'Save', Icons.save, () {
                  // Handle Save option
                  BlocProvider.of<InvoiceBloc>(context).add(
                      PrintBill(custName, custNum, custAdd, discount, "save"));

                  Navigator.of(context).pop();
                }),
                _buildOptionButton(context, 'Print', Icons.print, () {
                  // Handle Print option
                  BlocProvider.of<InvoiceBloc>(context).add(
                      PrintBill(custName, custNum, custAdd, discount, "print"));
                  // Navigator.of(context).pop();
                  // Add your print functionality here
                }),
                _buildOptionButton(context, 'Share', Icons.share, () {
                  // Handle Share option
                  BlocProvider.of<InvoiceBloc>(context).add(
                      PrintBill(custName, custNum, custAdd, discount, "share"));
                  // Navigator.of(context).pop();
                  // Add your share functionality here
                }),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, String label, IconData icon, Function onPressed) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () => onPressed(),
        leading: Icon(icon),
        title: Text(label),
      ),
    );
  }
}

void showPrintDialog1(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return billoptions();
    },
  );
}

class billoptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Options'),
      content: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          Common cm = Common();

          if (state is InvoiceLoading) {
            return const SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is InvoiceDataState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOptionButton(context, 'Print', Icons.print, () {
                  cm
                      .showPrintPreview(context, state.dataList, 'print', true)
                      .then((value) {
                    Navigator.of(context).pop();
                    // pushAndRemoveUntil(
                    //   MaterialPageRoute(
                    //     builder: (context) => billReport(title: "Invoice"),
                    //   ),
                    //   (route) => false, // Clear all routes from the stack.
                    // );
                  });
                }),
                _buildOptionButton(context, 'Share', Icons.share, () {
                  cm
                      .showPrintPreview(context, state.dataList, 'share', true)
                      .then((value) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    // Navigator.of(context).pushAndRemoveUntil(
                    //   MaterialPageRoute(
                    //     builder: (context) => billReport(title: "Invoice"),
                    //   ),
                    //   (route) => false, // Clear all routes from the stack.
                    // );
                  });
                  // Navigator.of(context).pop();
                  // Navigator.of(context).pop();
                  // Add your share functionality here
                }),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildOptionButton(
      BuildContext context, String label, IconData icon, Function onPressed) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        onTap: () => onPressed(),
        leading: Icon(icon),
        title: Text(label),
      ),
    );
  }
}
