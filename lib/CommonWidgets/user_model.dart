class UserModel {
  int? total_records;
  int? number_of_pages;
  int? currentPage;
  List<ItemModel>? data;
  String? status;
  Support? support;

  UserModel(
      {this.status,
      this.total_records,
      this.number_of_pages,
      this.currentPage,
      this.data,
      this.support});

  UserModel.fromJson(Map<dynamic, dynamic> json) {
    total_records = json['total_records'];
    number_of_pages = json['number_of_pages'];
    currentPage = json['current_page'];
    status = json['status'];
    if (json['status'] == "success" && json['data'] != null) {
      data = <ItemModel>[];
      json['data']?.forEach((v) {
        data!.add(ItemModel.fromJson(v));
      });
    }
    // support =
    //     json['support'] != null ? Support.fromJson(json['support']) : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data['total_records'] = total_records;
    data['number_of_pages'] = number_of_pages;
    data['current_page'] = currentPage;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    // if (this.support != null) {
    //   data['support'] = this.support!.toJson();
    // }
    return data;
  }
}

class Data {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;

  Data({this.id, this.email, this.firstName, this.lastName, this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['avatar'] = avatar;
    return data;
  }
}

class ItemModel {
  String? item_id;
  String? item_name;
  String? item_hsn;
  String? item_unit;
  String? item_gst;
  String? basic_value;
  String? whole_sale_value;

  ItemModel({
    this.item_id,
    this.item_name,
    this.item_hsn,
    this.item_unit,
    this.item_gst,
    this.basic_value,
    this.whole_sale_value,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    item_id = json['item_id'];
    item_name = json['item_name'];
    item_hsn = json['item_hsn'];
    item_unit = json['item_unit'];
    item_gst = json['item_gst'];
    basic_value = json['basic_value'];
    whole_sale_value = json['whole_sale_value'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data['item_id'] = item_id;
    data['item_name'] = item_name;
    data['item_hsn'] = item_hsn;
    data['item_unit'] = item_unit;
    data['item_gst'] = item_gst;
    data['basic_value'] = basic_value;
    data['whole_sale_value'] = whole_sale_value;
    return data;
  }
}

class Support {
  String? url;
  String? text;

  Support({this.url, this.text});

  Support.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['text'] = text;
    return data;
  }
}
