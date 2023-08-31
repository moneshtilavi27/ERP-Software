import 'package:flutter/cupertino.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class Common {
  Future<void> showPrintPreview(BuildContext context) async {
    final doc = pw.Document();

    // Load the Noto Sans font
    final font = await PdfGoogleFonts.notoSansRegular();

    final items = [
      BillItem('Item 1', 10.0, 2),
      BillItem('Item 2', 5.0, 3),
      BillItem('Item 3', 8.0, 1),
    ];

    final totalAmount = items.fold<double>(
        0, (total, item) => total + (item.price * item.quantity));

    doc.addPage(
      pw.Page(
        build: (context) {
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
                        'Market Mart',
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
                          pw.Text('Date: 2023-08-27'),
                          pw.Text('Time: 15:30'),
                        ],
                      ),
                      pw.Text('Cashier: John Doe',
                          textAlign: pw.TextAlign.left),
                      pw.Text('Invoice #: 12345', textAlign: pw.TextAlign.left),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 120,
                            child: pw.Text('Item'),
                          ),
                          pw.SizedBox(
                            width: 50,
                            child: pw.Text('Price'),
                          ),
                          pw.SizedBox(
                            width: 50,
                            child: pw.Text('Qty'),
                          ),
                          pw.SizedBox(
                            width: 50,
                            child: pw.Text('Total (\$)'),
                          ),
                        ],
                      ),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(child: pw.Text('Product 1')),
                          pw.Text('2'),
                          pw.Text('10.99'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(child: pw.Text('Product 2')),
                          pw.Text('1'),
                          pw.Text('5.49'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(child: pw.Text('Product 3')),
                          pw.Text('3'),
                          pw.Text('2.99'),
                        ],
                      ),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Subtotal'),
                          pw.Text('19.47'),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Tax (7%)'),
                          pw.Text('1.36'),
                        ],
                      ),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text('Total'),
                          pw.Text('20.83'),
                        ],
                      ),
                      pw.Divider(),
                      pw.Text('Payment Method: Cash'),
                      pw.Text('Change Due: 30.00'),
                      pw.SizedBox(height: 10),
                      pw.Text('Thank you for shopping!'),
                      pw.Text('Have a great day!'),
                    ],
                  )));
        },
        // fonts: [font], // Specify the font
      ),
    );

    final pdf = doc.save();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf,
    );
  }
}

class BillItem {
  final String name;
  final double price;
  final int quantity;

  BillItem(this.name, this.price, this.quantity);
}
