import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  // Initial Selected Value
  final String defaultValue;
  final String? helpText;
  final IconData? prefixIcon, suffixIcon;
  final bool? isPassword, enabled, readOnly;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  int? maxLength;
  Function? onChange;

  var items = [
    'pcs',
    'kg',
    'gm',
    'Ltr',
    'ml',
    'dz',
    'pkt',
    'btl',
    'ctn',
    'bdl',
    'bch',
    'box',
    'bag',
    'jar',
    'can',
    'roll',
    'sack',
    'tin',
    'tray',
    'pouch',
    'unit',
    '-'
  ];

  Dropdown(
      {Key? key,
      required this.helpText,
      this.suffixIcon,
      this.prefixIcon,
      this.isPassword = false,
      this.enabled = true,
      this.readOnly = false,
      this.onChange,
      this.textInputType,
      this.focusNode,
      this.textAlign,
      this.maxLength,
      required this.defaultValue})
      : super(key: key);

  get onChanged => null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 0, 0, 4),
            child: Text(helpText!, textAlign: TextAlign.start),
          ),
          DropdownButtonFormField(
            // Initial Value
            value: defaultValue,
            menuMaxHeight: 400,

            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: onChange != null
                ? ((value) => {onChange!(value)})
                : (value) => {},
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
              border: const OutlineInputBorder(),
              prefixIcon: prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 0),
                      child: Icon(
                        prefixIcon,
                        size: 25,
                      )),
              suffixIcon: suffixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 0),
                      child: Icon(
                        suffixIcon,
                        size: 25,
                      )),
            ),
            dropdownColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
