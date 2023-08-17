import 'dart:convert';

import 'package:erp/CommonWidgets/user_model.dart';
import 'package:flutter/material.dart';

import '../service/API/api.dart';
import '../service/API/api_methods.dart';

class SearchBox extends StatefulWidget {
  late final TextEditingController controller;
  final String? hintText, helpText;
  final IconData? prefixIcon, suffixIcon;
  final double? listWidth;
  final Function? onChange;
  final Function onSelected;
  final List<String>? options;

  SearchBox(
      {Key? key,
      required this.controller,
      this.hintText,
      this.helpText,
      this.prefixIcon,
      this.suffixIcon,
      this.listWidth,
      this.onChange,
      required this.onSelected,
      this.options})
      : super(key: key);

  @override
  _SearchBoxState createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getItemList();
  }

  getItemList() async {
    APIMethods obj = new APIMethods();
    await obj.postData(API.itemMaster, {'request': "get"}).then((res) {
      // print("important data===>" + res.toString());
      setState(() {
        userModel = UserModel.fromJson(json.decode(res.toString()));
      });
    }).catchError((error) {
      print(error);
    });

    // await obj.getData('https://reqres.in/api/users?page=2', {}).then((res) {
    //   // print("search box");
    //   // print("important data===>" + res.toString());
    //   // options = res.data['data'];
    //   // setState(() {
    //   //   userModel = UserModel.fromJson(json.decode(res.toString()));
    //   // });
    // }).catchError((error) {
    //   print(error);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<ItemModel>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        widget.controller?.text = textEditingValue.text;
        if (textEditingValue.text == '') {
          return List.empty();
        }
        return userModel!.data!
            .where((element) => element.item_name!
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            .toList();
      },
      fieldViewBuilder: (BuildContext context, textEditingController, focusNode,
          onFieldSubmitted) {
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
                  style: const TextStyle(fontSize: 14),
                  onChanged: widget.onChange != null
                      ? ((value) {
                          widget.onChange!(value);
                        })
                      : (value) => {},
                  onEditingComplete: () {
                    print("complete");
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                    border: OutlineInputBorder(),
                    prefixIcon: widget.prefixIcon == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            child: Icon(
                              widget.prefixIcon,
                              size: 25,
                            )),
                    suffixIcon: widget.suffixIcon == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            child: Icon(
                              widget.suffixIcon,
                              size: 25,
                            )),
                  )),
            ],
          ),
        );
      },
      optionsViewBuilder: (BuildContext context, Function onSelected,
          Iterable<ItemModel> options) {
        return Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 3, 0, 0),
              child: Material(
                elevation: 4.0,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: 0.0,
                      maxHeight: 200,
                      maxWidth: widget.listWidth ?? 350),
                  child: ListView.builder(
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      ItemModel d = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(d);
                        },
                        child: ListTile(
                          title: Text(d.item_name!),
                          // leading: Image.network(
                          //   d.avatar!,
                          //   width: 50,
                          //   height: 50,
                          //   fit: BoxFit.fill,
                          // ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
      },
      onSelected: widget.onSelected != null
          ? ((value) => {widget.onSelected(value)})
          : (value) => {},
      displayStringForOption: (ItemModel d) => '${d.item_name!}',
      optionsMaxHeight: 1,
    );
  }
}
