import 'dart:convert';

import 'package:erp/service/API/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/API/api_methods.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(IntialState()) {
    APIMethods obj = APIMethods();
    featchItemData({'request': "get"});

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
      featchItemData({'request': "get", "item_name": "monesh"});
    });

    on<FilterItemEvent>((event, emit) => featchItemData(
        {'request': "getItemNames", "item_name": event.item_name}));

    on<AddItemEvent>((event, emit) async {
      try {
        APIMethods obj = APIMethods();
        // double value =
        //     double.parse(event.basic_value) * double.parse(event.item_quant);
        // print(value);
        Map<String, dynamic> data = {
          "request": "add",
          "data": {
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

    on<UpdateItemEvent>((event, emit) async {
      try {
        APIMethods obj = APIMethods();
        double value =
            double.parse(event.basic_value) * double.parse(event.item_quant);
        Map<String, dynamic> data = {
          "request": "update",
          "item_id": event.item_id,
          "data": {
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
        APIMethods obj = APIMethods();
        Map<String, dynamic> data = {
          "request": "deleteItem",
          "item_id": event.item_id,
          "user_id": 1
        };

        obj.postData(API.invoice, data).then((res) {
          if (res.data['status'] == "success") {
            featchItemData({'request': "get"});
          }
        });
      } catch (e) {
        print(e.toString());
        throw ErrorInvoiceState(e.toString());
      }
    });

    on<PrintBill>((event, emit) async {
      try {
        Map<String, dynamic> customerData = {
          "request": "add",
          "data": {
            "customer_name": event.customerName,
            "customer_mob": event.customerNumber,
            "customer_address": event.customerAddress,
          }
        };
        String custId = await addCustomer(customerData);
        print("custid  $custId");

        Map<String, dynamic> invoiceData = {
          "request": "getInvoiceNumber",
          "user_id": "1",
          "customer_id": custId,
          "discount": "0"
        };
        int invoiceNum = await getBillNumber(invoiceData);
        print("invoiceNum  $invoiceNum");

        Map<String, dynamic> invoiceData1 = {
          "request": "transferItem",
          "user_id": "1",
          "invoiceNumber": invoiceNum
        };
        await transferItems(invoiceData1);

        Map<String, dynamic> getBill = {
          "request": "getBill",
          "user_id": "1",
          "invoiceNumber": invoiceNum
        };
        await getInvoiceData(getBill, event.status);
        // if (event.status == "print") {
        //   emit(const InvoiceStatus("print"));
        // }
        // if (event.status == "save") {
        //   emit(const InvoiceStatus("save"));
        // }
      } catch (e) {
        emit(ErrorInvoiceState(e.toString()));
      }
    });

    on<CancelBill>((event, emit) {
      try {
        APIMethods obj = APIMethods();
        Map<String, dynamic> data = {"request": "cancelBill", "user_id": "1"};

        obj.postData(API.invoice, data).then((res) {
          if (res.data['status'] == "success") {
            featchItemData({'request': "get"});
          }
        });
      } catch (e) {
        print(e.toString());
        throw ErrorInvoiceState(e.toString());
      }
    });
  }

  void addUpdate(Map<String, dynamic> data) async {
    APIMethods obj = APIMethods();
    await obj.postData(API.invoice, data).then((res) async {
      try {
        if (res.data['status'] == "success") {
          featchItemData({'request': "get"});
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

      if (res.data['status'] == "success") {
        print(res.data['inserted_id']);
        return res.data['inserted_id'];
      } else {
        throw ErrorInvoiceState(res.data['data']);
      }
    } catch (e) {
      print(e.toString());
      throw ErrorInvoiceState(e.toString());
    }
  }

  Future<int> getBillNumber(Map<String, dynamic> data) async {
    try {
      APIMethods obj = APIMethods();
      final res = await obj.postData(API.invoice, data);

      if (res.data['status'] == "success") {
        print(res.data['invoice_number']);
        return res.data['invoice_number'];
      } else {
        throw ErrorInvoiceState(res.data['data']);
      }
    } catch (e) {
      print(e.toString());
      throw ErrorInvoiceState(e.toString());
    }
  }

  Future transferItems(Map<String, dynamic> data) async {
    try {
      APIMethods obj = APIMethods();
      final res = await obj.postData(API.invoice, data);

      if (res.data['status'] == "success") {
        print(res);
      } else {
        throw ErrorInvoiceState(res.data['data']);
      }
    } catch (e) {
      print(e.toString());
      throw ErrorInvoiceState(e.toString());
    }
  }

  Future getInvoiceData(Map<String, dynamic> data, String status) async {
    try {
      APIMethods obj = APIMethods();
      obj.postData(API.invoice, data).then((res) {
        if (res.data['status'] == "success") {
          emit(InvoiceDataState(res.data['data'], status));
        }
      });
    } catch (e) {
      print(e.toString());
      throw ErrorInvoiceState(e.toString());
    }
  }
}
