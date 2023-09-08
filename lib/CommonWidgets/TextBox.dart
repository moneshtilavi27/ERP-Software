import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextBox extends StatefulWidget {
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
  Function? validator;

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
      this.validator,
      this.textInputType,
      this.focusNode,
      this.textInputFormatter,
      this.textAlign,
      this.maxLength})
      : super(key: key);

  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ?? false;
  }

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
            child: Text(widget.helpText!, textAlign: TextAlign.start),
          ),
          TextFormField(
            style: const TextStyle(fontSize: 14),
            maxLength: widget.maxLength,
            textAlign: widget.textAlign ?? TextAlign.start,
            focusNode: widget.focusNode,
            inputFormatters: widget.textInputFormatter,
            keyboardType: widget.textInputType,
            onChanged: widget.onChange != null
                ? ((value) => {widget.onChange!(value)})
                : (value) => {},
            controller: widget.controller,
            readOnly: widget.readOnly == false ? false : true,
            enabled: widget.enabled == false ? false : true,
            obscureText: _obscureText, // Controls password visibility
            validator: (input) {
              // Use the passed validator function
              if (widget.validator != null) {
                return widget.validator!(input);
              }
              return null;
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.fromLTRB(10, 12, 0, 12),
              border: const OutlineInputBorder(),
              prefixIcon: widget.prefixIcon == null
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 0),
                      child: Icon(
                        widget.prefixIcon,
                        size: 25,
                      )),
              suffixIcon: widget.isPassword == true
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.suffixIcon == null
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 0, right: 0, bottom: 0),
                          child: InkWell(
                            onTap: () {},
                            child: Icon(
                              widget.suffixIcon,
                              size: 25,
                            ),
                          )),
            ),
          ),
        ],
      ),
    );
  }
}
