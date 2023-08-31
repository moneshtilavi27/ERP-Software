import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextBox extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText, helpText;
  final IconData? prefixIcon, suffixIcon;
  final bool? isPassword, enabled, readOnly;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  int? maxLength;
  Function? onChange;

  TextBox(
      {Key? key,
      this.controller,
      this.hintText,
      required this.helpText,
      this.suffixIcon,
      this.prefixIcon,
      this.isPassword = false,
      this.enabled = true,
      this.readOnly = false,
      this.onChange,
      this.textInputType,
      this.focusNode,
      this.textInputFormatter,
      this.textAlign,
      this.maxLength})
      : super(key: key);

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
          TextFormField(
            style: const TextStyle(fontSize: 14),
            maxLength: maxLength,
            textAlign: textAlign ?? TextAlign.start,
            focusNode: focusNode,
            inputFormatters: textInputFormatter,
            keyboardType: textInputType,
            onChanged: onChange != null
                ? ((value) => {onChange!(value)})
                : (value) => {},
            controller: controller,
            readOnly: readOnly == false ? false : true,
            enabled: enabled == false ? false : true,
            validator: (input) {
              if (input == 'a') {
                print("abc");
                return 'Please enter $hintText !';
              }
              return null;
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
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
          ),
        ],
      ),
    );
  }
}
