import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(
    BuildContext context, String msg, Function onPressed) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('$msg Dialog'),
        content: Text(camelCase('Are you sure you want to $msg?')),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              onPressed();
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Ok"),
          ),
        ],
      );
    },
  );
}

void showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Alert Dialog'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

String camelCase(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

class InternetStatusMessage extends StatelessWidget {
  final bool isConnected;

  InternetStatusMessage({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: isConnected ? 2000 : 500),
      height:
          isConnected ? 0 : 50, // Set the height to 0 to hide it when connected
      color: isConnected ? Colors.green : Colors.red,
      child: Center(
        child: Text(
          isConnected
              ? 'Internet Connection Successfull'
              : 'No internet connection',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

double calculateQuantity(dynamic qty, String unit, dynamic rate) {
  double stk = 0;
  try {
    qty = (qty != null && qty.isNotEmpty) ? double.tryParse(qty) ?? 0 : 0;
    rate = (rate != null && rate.isNotEmpty) ? double.tryParse(rate) ?? 0 : 0;

    print(rate);

    if (unit == 'gm' || unit == 'ml') {
      stk = qty / 1000;
    }
    if (unit == 'kg' ||
        unit == 'ltr' ||
        unit == 'btl' ||
        unit == 'pkt' ||
        unit == 'pcs' ||
        unit == 'pouch' ||
        unit == '-' ||
        unit == 'hgr') {
      stk = qty / 1;
    }
    if (unit == 'qtl') {
      stk = qty * 100;
    }
    double value = stk * rate;
    print(unit);
    return value;
  } catch (e) {
    print(e.toString());
    return 0;
  }
}
