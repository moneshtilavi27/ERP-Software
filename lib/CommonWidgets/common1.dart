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
            child: Text("Ok"),
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
        title: Text('Alert Dialog'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Close'),
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
