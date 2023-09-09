import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class Common {
  Future<void> showPrintPreview(BuildContext context,
      Map<String, dynamic> jsonData, bool gstEnabled) async {
    final doc = pw.Document();

    final font = await PdfGoogleFonts.notoSansRegular();

    final billData = jsonData['billdata'] as List<dynamic>;
    final billItems = jsonData['billItem'] as List<dynamic>;

    final billNumber = billData.isNotEmpty ? billData[0]['number'] : '';
    final fileName = 'Bill_$billNumber.pdf'; // Set the document name
    final customerName =
        billData.isNotEmpty ? billData[0]['customer_name'] : '';
    final customerAddress =
        billData.isNotEmpty ? billData[0]['customer_address'] : '';
    final customerMobile =
        billData.isNotEmpty ? billData[0]['customer_mob'] : '';
    final discount = billData.isNotEmpty ? billData[0]['discount'] : '';
    final createdDate = billData.isNotEmpty ? billData[0]['created'] ?? '' : '';

    final billDate =
        createdDate.isNotEmpty ? DateTime.parse(createdDate).toString() : '';
    final formattedBillDate =
        billDate.isNotEmpty ? _formatDateTime(billDate) : '';

    double totalAmount = 0;
    double discountAmount = 0;
    double cgstAmount = 0;
    double sgstAmount = 0;

    doc.addPage(
      pw.Page(
        build: (context) {
          final itemsList = <pw.Widget>[];

          itemsList.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 100,
                  child: pw.Text('Item'),
                ),
                pw.SizedBox(
                  width: 40,
                  child: pw.Text('Qty'),
                ),
                pw.SizedBox(
                  width: 40,
                  child: pw.Text('Rate'),
                ),
                pw.SizedBox(
                  width: 50,
                  child: pw.Text('Total (\$)'),
                ),
              ],
            ),
          );

          itemsList.add(pw.Divider());

          for (final item in billItems) {
            final itemName = item['item_name'] ?? '';
            final qty = item['qty'] ?? '0';
            final rate = item['rate'] ?? '0';
            final value = item['value'] ?? '0';
            final gstPercentage = item['item_gst'] ?? '0';
            print(gstPercentage);

            totalAmount += double.parse(value);

            final gstAmount =
                (double.parse(value) * double.parse(gstPercentage)) / 100;
            final cgst = gstAmount / 2;
            final sgst = gstAmount / 2;

            cgstAmount += cgst;
            sgstAmount += sgst;

            itemsList.add(
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 100,
                    child: pw.Text(itemName),
                  ),
                  pw.SizedBox(
                    width: 40,
                    child: pw.Text(qty),
                  ),
                  pw.SizedBox(
                    width: 40,
                    child: pw.Text(rate),
                  ),
                  pw.SizedBox(
                    width: 50,
                    child: pw.Text(value),
                  ),
                ],
              ),
            );
          }

          itemsList.add(pw.Divider());

          if (gstEnabled) {
            itemsList.add(
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Subtotal'),
                  pw.Text(totalAmount.toStringAsFixed(2)),
                ],
              ),
            );

            itemsList.add(
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('CGST (${cgstAmount.toStringAsFixed(2)})'),
                  pw.Text(cgstAmount.toStringAsFixed(2)),
                ],
              ),
            );

            itemsList.add(
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('SGST (${sgstAmount.toStringAsFixed(2)})'),
                  pw.Text(sgstAmount.toStringAsFixed(2)),
                ],
              ),
            );

            // totalAmount += cgstAmount + sgstAmount;
          }

          // Discount calculation
          if (discount.isNotEmpty) {
            // discountAmount = (totalAmount * double.parse(discount)) / 100;
            discountAmount = double.parse(discount);
            totalAmount -= discountAmount;
          }

          itemsList.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Discount'),
                pw.Text(discountAmount.toStringAsFixed(2)),
              ],
            ),
          );

          itemsList.add(
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total Amount'),
                pw.Text(totalAmount.toStringAsFixed(2)),
              ],
            ),
          );

          return pw.Center(
            child: pw.Container(
              width: 300,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'Ono Mart',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('1234 Market Street, Cityville'),
                  pw.Text('Phone: (123) 456-7890'),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Bill Date: $formattedBillDate'),
                    ],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [pw.Text('Bill Number: $billNumber')],
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Customer: $customerName'),
                      pw.Text('Mob: $customerMobile'),
                    ],
                  ),
                  pw.Divider(),
                  ...itemsList,
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Text('Thank you for shopping!'),
                  pw.Text('Have a great day!'),
                ],
              ),
            ),
          );
        },
      ),
    );

    final pdf = doc.save();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf,
      name: fileName, // Specify the document name here
    );
  }

  String _formatDateTime(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    final formattedDate =
        "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    final formattedTime =
        "${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}:${parsedDate.second.toString().padLeft(2, '0')}";

    return '$formattedDate $formattedTime';
  }
}
