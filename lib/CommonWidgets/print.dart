import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintScreen extends StatelessWidget {
  const PrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Bill'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showPrintPreview(context);
          },
          child: const Text('Print Preview'),
        ),
      ),
    );
  }

  Future<void> _showPrintPreview(BuildContext context) async {
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
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Market Mart',
                        textAlign: pw.TextAlign.center,
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
                      pw.Text('Cashier: John Doe'),
                      pw.Text('Invoice #: 12345'),
                      pw.Divider(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                        children: [
                          pw.Text('Item'),
                          pw.Text('Qty'),
                          pw.Text('Price (\$)'),
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
