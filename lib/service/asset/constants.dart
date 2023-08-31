import 'package:flutter/material.dart';

class ConstantValues {
  static const double customFontSize = 20.0;

  static getTableTheams(context) {
    return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      // All rows will have the same selected color.
      if (states.contains(MaterialState.selected)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.03);
      }
      // Even rows will have a grey color.
      // if (index.isEven) {
      //   return Colors.grey.withOpacity(0.3);
      // }
      return null; // Use default value for other states and odd rows.
    });
  }
}
