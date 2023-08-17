import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';

class SearchBox1 extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText, helpText;
  final IconData? prefixIcon, suffixIcon;
  Function? future;

  SearchBox1(
      {Key? key,
      required this.controller,
      this.hintText,
      required this.helpText,
      this.suffixIcon,
      this.future,
      this.prefixIcon})
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
          TextFieldSearch(
            future: future,
            textStyle: const TextStyle(fontSize: 14),
            controller: controller,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
              border: OutlineInputBorder(),
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
            scrollbarDecoration: ScrollbarDecoration(
                controller: ScrollController(),
                theme: ScrollbarThemeData(
                    radius: Radius.circular(30.0),
                    thickness: MaterialStateProperty.all(20.0),
                    isAlwaysShown: true,
                    trackColor: MaterialStateProperty.all(Colors.red))),
            label: 'monu',
          ),
        ],
      ),
    );
  }
}
