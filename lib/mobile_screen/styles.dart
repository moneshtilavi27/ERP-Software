import 'package:flutter/material.dart';

class ElevatedButtonStyle {
  static ButtonStyle greenButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(8.0), // Adjust this value to make it square
    ),
  );
  static ButtonStyle redButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(8.0), // Adjust this value to make it square
    ),
  );
}
