import 'package:flutter/material.dart';

class CustomSnackbar {
  showSnackbar(bgColor, textcolor, text) {
    var snackBar = SnackBar(
      backgroundColor: bgColor,
      content: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold, color: textcolor, fontSize: 20),
      ),
    );
    return snackBar;
  }
}
