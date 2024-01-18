import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/Blocs/Invoice/invoice_state.dart';
import 'package:erp/Constants/Colors.dart';
import 'package:erp/mobile_screen/printOptionDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowInvoice extends StatelessWidget {
  final String invoiceNum;

  ShowInvoice({required this.invoiceNum});

  @override
  Widget build(BuildContext context) {
    final invoiceBloc = BlocProvider.of<InvoiceBloc>(context);
    invoiceBloc
        .add(GetInvoiceData(invoice_number: invoiceNum, status: 'print'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Preview'),
        backgroundColor: TheamColors.theamColor,
        foregroundColor: TheamColors.white,
      ),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceDataState) {
            final billData = state.dataList['billdata'][0];
            final billItems = state.dataList['billItem'];

            double totalAmount = 0;
            double totalDiscount = double.parse(billData['discount'] ?? "0");
            double totalCGST = 0;
            double totalSGST = 0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice Number: ${billData['number']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Customer Name: ${billData['customer_name']}'),
                  Text('Customer Mobile: ${billData['customer_mob']}'),
                  Text(
                      'Customer Address: ${billData['customer_address'] ?? 'N/A'}'),
                  SizedBox(height: 10),
                  Divider(
                    height: 5,
                  ),
                  Text(
                    'Bill Items:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                              child: Center(
                                  child: Text('SL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text('Item Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text('Qty',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text('Rate',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                          TableCell(
                              child: Center(
                                  child: Text('Total',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)))),
                        ],
                      ),
                      for (int i = 0; i < billItems.length; i++)
                        TableRow(
                          children: [
                            TableCell(
                                child: Center(child: Text((i + 1).toString()))),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  billItems[i]['item_name'],
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            TableCell(
                                child: Center(
                                    child: Text(
                                        '${billItems[i]['qty']} ${billItems[i]['unit']}'))),
                            TableCell(
                                child: Center(
                                    child: Text('₹${billItems[i]['rate']}'))),
                            TableCell(
                                child: Center(
                                    child: Text(
                                        '₹${_calculateTotalAmountForItem(billItems[i])}'))),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                          'Total Amount: ₹${_calculateTotalAmount(billItems)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Total CGST: ₹${_calculateTotalCGST(billItems)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Total SGST: ₹${_calculateTotalSGST(billItems)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Discount: ₹${totalDiscount.toStringAsFixed(2)}'),
                    ],
                  ),
                  Divider(
                    height: 5,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Grand Total: ₹${_calculateGrandTotal(billItems, totalDiscount)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // Handle the print action here
          print("monu");
          showPrintDialog1(context);
        },
        child: Text('Print'),
      ),
    );
  }

  double _calculateTotalAmount(List<dynamic> billItems) {
    double totalAmount = 0;
    for (var item in billItems) {
      totalAmount += _calculateTotalAmountForItem(item);
    }
    return totalAmount;
  }

  double _calculateTotalAmountForItem(Map<String, dynamic> item) {
    return double.parse(item['value']);
  }

  double _calculateTotalCGST(List<dynamic> billItems) {
    double totalCGST = 0;
    for (var item in billItems) {
      totalCGST += _calculateCGST(item);
    }
    return totalCGST;
  }

  double _calculateTotalSGST(List<dynamic> billItems) {
    double totalSGST = 0;
    for (var item in billItems) {
      totalSGST += _calculateSGST(item);
    }
    return totalSGST;
  }

  double _calculateCGST(Map<String, dynamic> item) {
    double cgstPercent = (double.parse(item['item_gst']) / 2);
    double cgstAmount = (cgstPercent / 100) * double.parse(item['value']);
    return cgstAmount;
  }

  double _calculateSGST(Map<String, dynamic> item) {
    double sgstPercent = (double.parse(item['item_gst']) / 2);
    double sgstAmount = (sgstPercent / 100) * double.parse(item['value']);
    return sgstAmount;
  }

  double _calculateGrandTotal(List<dynamic> billItems, double discount) {
    double totalAmount = _calculateTotalAmount(billItems);
    double totalCGST = _calculateTotalCGST(billItems);
    double totalSGST = _calculateTotalSGST(billItems);
    // return totalAmount + totalCGST + totalSGST - discount;
    return totalAmount - discount;
  }
}
