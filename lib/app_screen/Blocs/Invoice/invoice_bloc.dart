import 'package:erp/service/API/api.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../service/API/api_methods.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(IntialState()) {
    late SharedPreferences sp;
    SharedPreferences.getInstance().then((value) {
      sp = value;
      print(value.getString('user_id').toString());
      featchItemData({
        'request': "get",
        "user_id": value.getString('user_id').toString(),
      });
    });

    on<CustomerDetailEvent>((event, emit) {
      if (event.customerName == "") {
        emit(const ErrorInvoiceState("Please enter Customer Name."));
      } else if (event.customerNumber == "") {
        emit(const ErrorInvoiceState("Please enter Customer Number"));
      } else if (event.customerAddress == "") {
        emit(const ErrorInvoiceState("Please enter Customer Address"));
      }
    });

    on<FeatchInvoiceEvent>((event, emit) async {
      featchItemData(
          {'request': "get", "user_id": sp.getString('user_id').toString()});
    });

    on<FilterItemEvent>((event, emit) => featchItemData(
        {'request': "getItemNames", "item_name": event.item_name}));

    on<AddProductEvent>((event, emit) async {
      try {
        sp = await SharedPreferences.getInstance();
        // double value =
        //     double.parse(event.basic_value) * double.parse(event.item_quant);
        // print(value);
        Map<String, dynamic> data = {
          "request": "add",
          "data": {
            "user_id": sp.getString('user_id'),
            "item_id": event.item_id,
            "item_name": event.item_name,
            "item_hsn": event.item_hsn,
            "item_gst": event.item_gst.isEmpty ? 0 : event.item_gst,
            "item_quant": event.item_quant,
            "item_unit": event.item_unit,
            "item_rate": event.basic_value,
            "item_value": event.value
          }
        };
        addUpdate(data);
      } catch (e) {
        emit(ErrorInvoiceState(e.toString()));
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      try {
        Map<String, dynamic> data = {
          "request": "update",
          "item_id": event.item_id,
          "data": {
            "user_id": sp.getString('user_id'),
            "item_name": event.item_name,
            "item_hsn": event.item_hsn,
            "item_gst": event.item_gst,
            "item_quant": event.item_quant,
            "item_unit": event.item_unit,
            "item_rate": event.basic_value,
            "item_value": event.value,
          }
        };
        addUpdate(data);
      } catch (e) {
        emit(ErrorInvoiceState(e.toString()));
      }
    });

    on<DeleteItemEvent>((event, emit) async {
      try {
        sp = await SharedPreferences.getInstance();
        APIMethods obj = APIMethods();
        Map<String, dynamic> data = {
          "request": "deleteItem",
          "item_id": event.item_id,
          "user_id": sp.getString('user_id')
        };

        obj.postData(API.invoice, data).then((res) {
          if (res.data['status'] == "success") {
            featchItemData({
              'request': "get",
              "user_id": sp.getString('user_id').toString()
            });
          }
        });
      } catch (e) {
        throw ErrorInvoiceState(e.toString());
      }
    });

    on<PrintBill>((event, emit) async {
      try {
        sp = await SharedPreferences.getInstance();
        Map<String, dynamic> customerData = {
          "request": "add",
          "data": {
            "customer_name": event.customerName,
            "customer_mob": event.customerNumber,
            "customer_address": event.customerAddress,
          }
        };

        String custId = await addCustomer(customerData);

        Map<String, dynamic> invoiceData = {
          "request": "getInvoiceNumber",
          "user_id": sp.getString('user_id'),
          "customer_id": custId,
          "discount": "0"
        };
        int invoiceNum = await getBillNumber(invoiceData);

        Map<String, dynamic> invoiceData1 = {
          "request": "transferItem",
          "user_id": sp.getString('user_id'),
          "invoiceNumber": invoiceNum
        };
        await transferItems(invoiceData1);

        Map<String, dynamic> getBill = {
          "request": "getBill",
          "user_id": sp.getString('user_id'),
          "invoiceNumber": invoiceNum
        };
        getInvoiceData(getBill, event.status);
      } catch (e) {
        emit(ErrorInvoiceState(e.toString()));
      }
    });

    on<CancelBill>((event, emit) async {
      try {
        APIMethods obj = APIMethods();
        sp = await SharedPreferences.getInstance();
        Map<String, dynamic> data = {
          "request": "cancelBill",
          "user_id": sp.getString('user_id')
        };

        obj.postData(API.invoice, data).then((res) {
          if (res.data['status'] == "success") {
            featchItemData({'request': "get"});
          }
        });
      } catch (e) {
        throw ErrorInvoiceState(e.toString());
      }
    });
  }

  void addUpdate(Map<String, dynamic> data) async {
    APIMethods obj = APIMethods();
    await obj.postData(API.invoice, data).then((res) async {
      try {
        if (res.data['status'] == "success") {
          featchItemData(
              {'request': "get", 'user_id': data['data']!['user_id']});
          emit(itemAddUpdateState());
        } else {
          emit(ErrorInvoiceState(res.data['data']));
        }
      } catch (e) {
        emit(ErrorInvoiceState(e.toString()));
      }
    }).catchError((error) {
      emit(ErrorInvoiceState(error));
    });
  }

  void featchItemData(Map<String, String> data) async {
    try {
      APIMethods obj = APIMethods();
      Map<String, String> para = data;
      await obj.postData(API.invoice, para).then((res) {
        if (res.data['status'] == "success") {
          print(res);
          emit(InvoiceItemListState(res.data['data']));
        }
      });
    } catch (e) {
      emit(ErrorInvoiceState(e.toString()));
    }
  }

  Future<String> addCustomer(Map<String, dynamic> data) async {
    try {
      APIMethods obj = APIMethods();
      final res = await obj.postData(API.customer, data);
      print(res);
      if (res.data['status'] == "success") {
        return res.data['inserted_id'];
      } else {
        throw ErrorInvoiceState(res.data['data']);
      }
    } catch (e) {
      throw ErrorInvoiceState(e.toString());
    }
  }

  Future<int> getBillNumber(Map<String, dynamic> data) async {
    try {
      APIMethods obj = APIMethods();
      final res = await obj.postData(API.invoice, data);

      if (res.data['status'] == "success") {
        return res.data['invoice_number'];
      } else {
        throw ErrorInvoiceState(res.data['data']);
      }
    } catch (e) {
      throw ErrorInvoiceState(e.toString());
    }
  }

  Future transferItems(Map<String, dynamic> data) async {
    try {
      APIMethods obj = APIMethods();
      final res = await obj.postData(API.invoice, data);

      if (res.data['status'] == "success") {
      } else {
        throw ErrorInvoiceState(res.data['data']);
      }
    } catch (e) {
      throw ErrorInvoiceState(e.toString());
    }
  }

  Future getInvoiceData(Map<String, dynamic> data, String status) async {
    try {
      APIMethods obj = APIMethods();
      obj.postData(API.invoice, data).then((res) {
        if (res.data['status'] == "success") {
          emit(InvoiceDataState(res.data['data'], status, true));
        }
      });
    } catch (e) {
      throw ErrorInvoiceState(e.toString());
    }
  }
}
