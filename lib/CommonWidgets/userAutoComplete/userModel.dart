class UserModel {
  int? total_records;
  int? number_of_pages;
  int? currentPage;
  List<UserList>? data;
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
    try {
      total_records = json['total_records'];
      number_of_pages = json['number_of_pages'];
      currentPage = json['current_page'];
      status = json['status'];
      if (json['status'] == "success" && json['data'] != null) {
        data = <UserList>[];
        json['data']?.forEach((v) {
          data!.add(UserList.fromJson(v));
        });
      }
      support =
          json['support'] != null ? Support.fromJson(json['support']) : null;
    } catch (e) {
      // Handle exceptions, e.g., log the error or show an error message
      print('Error parsing UserModel: $e');
    }
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
    if (this.support != null) {
      data['support'] = this.support!.toJson();
    }
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
    try {
      id = json['id'];
      email = json['email'];
      firstName = json['first_name'];
      lastName = json['last_name'];
      avatar = json['avatar'];
    } catch (e) {
      // Handle exceptions, e.g., log the error or show an error message
      print('Error parsing ItemModel: $e');
    }
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

class UserList {
  String? customer_id;
  String? customer_name;
  String? customer_address;
  String? customer_mob;

  UserList({
    this.customer_id,
    this.customer_name,
    this.customer_address,
    this.customer_mob,
  });

  UserList.fromJson(Map<String, dynamic> json) {
    try {
      customer_id = json['customer_id'];
      customer_name = json['customer_name'];
      customer_address = json['customer_address'];
      customer_mob = json['customer_mob'];
    } catch (e) {
      // Handle exceptions, e.g., log the error or show an error message
      print('Error parsing UserModel: $e');
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customer_id;
    data['customer_name'] = customer_name;
    data['customer_address'] = customer_address;
    data['customer_mob'] = customer_mob;
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
