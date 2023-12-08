import 'dart:convert';
import 'dart:ffi';

import 'package:erp/CommonWidgets/userAutoComplete/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../service/API/api.dart';
import '../../service/API/api_methods.dart';

class UserSearchBox extends StatefulWidget {
  TextEditingController controller;
  final String? hintText, helpText;
  final IconData? prefixIcon, suffixIcon;
  final double? listWidth;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? textInputType;
  final int? maxLength;
  final FocusNode? focusNode;
  final Function? onChange;
  final Function onSelected;
  final Function? onFocuseOut;
  final List<String>? options;

  late FocusNode _focusNode = FocusNode();

  UserSearchBox({
    Key? key,
    required this.controller,
    this.hintText,
    this.helpText,
    this.prefixIcon,
    this.suffixIcon,
    this.listWidth,
    this.textInputType,
    this.focusNode,
    this.textInputFormatter,
    this.maxLength,
    this.onChange,
    this.onFocuseOut,
    required this.onSelected,
    this.options,
  }) : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<UserSearchBox> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget._focusNode.addListener(_onFocusChange);
    getUserList();
  }

  void _onFocusChange() {
    if (!widget._focusNode.hasFocus) {
      widget.onFocuseOut!(widget.controller);
    } else {
      widget.onFocuseOut!(widget.controller);
    }
  }

  getUserList() async {
    APIMethods obj = APIMethods();
    await obj.postData(API.customer, {'request': "get"}).then((res) {
      setState(() {
        userModel = UserModel.fromJson(json.decode(res.toString()));
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<UserList>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        // widget.controller.text = textEditingValue.text;
        if (textEditingValue.text == '') {
          return List.empty();
        }
        return userModel!.data!
            .where((element) => element.customer_mob!
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      fieldViewBuilder: (BuildContext context, textEditingController, focusNode,
          onFieldSubmitted) {
        widget.controller = textEditingController;
        widget._focusNode = focusNode;
        widget.onFocuseOut!(widget.controller);
        widget._focusNode.addListener(_onFocusChange);
        final screenWidth = MediaQuery.of(context).size.width;
        // You can adjust these values as needed to control responsiveness
        final fontSize = screenWidth > 600 ? 14.0 : 12.0;
        final iconSize = screenWidth > 600 ? 25.0 : 20.0;

        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 0, 0, 4),
                child: Text(widget.helpText!, textAlign: TextAlign.start),
              ),
              TextField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  style: TextStyle(fontSize: fontSize),
                  onChanged: widget.onChange != null
                      ? ((value) {
                          widget.onChange!(value);
                        })
                      : (value) => {},
                  onEditingComplete: () {
                    print("complete");
                  },
                  inputFormatters: widget.textInputFormatter,
                  keyboardType: widget.textInputType,
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: "",
                    contentPadding: const EdgeInsets.fromLTRB(10, 12, 0, 12),
                    border: const OutlineInputBorder(),
                    prefixIcon: widget.prefixIcon == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            child: Icon(
                              widget.prefixIcon,
                            )),
                    suffixIcon: widget.suffixIcon == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            child: Icon(
                              widget.suffixIcon,
                            )),
                  )),
            ],
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, Function onSelected,
          Iterable<UserList> options) {
        return Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 3, 0, 0),
              child: Material(
                elevation: 3.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 0.0,
                      maxHeight: 300,
                      maxWidth: widget.listWidth ?? 320),
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      UserList d = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(d);
                        },
                        child: ListTile(
                          leading: Icon(Icons.verified_user),
                          title: Text(d.customer_name!),
                          subtitle: Text(d.customer_mob!),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
      },
      onSelected: widget.onSelected != null
          ? ((value) =>
              {print(value), widget.onSelected(value, widget.controller)})
          : (value) => {},
      displayStringForOption: (UserList d) => d.customer_mob!,
      optionsMaxHeight: 1,
    );
  }
}
