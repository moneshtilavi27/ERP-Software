import 'package:erp/service/API/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/API/api_methods.dart';
import 'invoice_event.dart';
import 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final SharedPreferences sp;

  InvoiceBloc(this.sp) : super(InitialState()) {
    _initialize();
  }

  void _initialize() {
    final userId = sp.getString('user_id');
    // if (userId != null) {
    //   featchItemData({'request': "get", "user_id": userId});
    // }

    on<CustomerDetailEvent>((event, emit) {
      if (event.customerName == "") {
        emit(const ErrorInvoiceState("Please enter Customer Name."));
      } else if (event.customerNumber == "") {
        emit(const ErrorInvoiceState("Please enter Customer Number"));
      } else if (event.customerAddress == "") {
        emit(const ErrorInvoiceState("Please enter Customer Address"));
      }
    });

    on<ClearStateEvent>((event, emit) {
      emit(InitialState()); // You can use a different state if needed
    });

    on<FeatchInvoiceEvent>((event, emit) async {
      final userId = sp.getString('user_id');
      await featchItemData({'request': "get", "user_id": userId});
    });

    on<FeatchInvoiceReportEvent>((event, emit) async {
      final userId = sp.getString('user_id');
      await getInvoiceReport({"request": "invoiceList", "user_id": userId});
    });

    on<FilterItemEvent>((event, emit) => featchItemData(
        {'request': "getItemNames", "item_name": event.item_name}));

    on<GetInvoiceData>((event, emit) async {
      try {
        // double value =
        //     double.parse(event.basic_value) * double.parse(event.item_quant);
        // print(value);
        Map<String, dynamic> getBill = {
          "request": "getBill",
          "user_id": sp.getString('user_id'),
          "invoiceNumber": event.invoice_number
        };
        emit(InvoiceItemListState([]));
        getInvoiceData(getBill, event.status);
      } catch (e) {
        emit(ErrorInvoiceState(e.toString()));
      }
    });

    on<AddProductEvent>((event, emit) async {
      try {
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
        await addUpdate(data);
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
        await addUpdate(data);
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
        emit(InvoiceLoading());
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
          "discount": event.discount
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
        emit(InvoiceItemListState([]));
        getInvoiceData(getBill, event.status);
      } catch (e) {
        emit(ErrorInvoiceState(e.toString()));
      }
    });

    on<CancelBill>((event, emit) async {
      try {
        APIMethods obj = APIMethods();
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

  Future addUpdate(Map<String, dynamic> data) async {
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

  Future featchItemData(Map<String, dynamic> data) async {
    try {
      APIMethods obj = APIMethods();
      await obj.postData(API.invoice, data).then((res) {
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
      print(data);
      APIMethods obj = APIMethods();
      final res = await obj.postData(API.invoice, data);

      if (res.data['status'] == "success") {
        return res.data['invoice_number'];
      } else {
        print(res);
        throw ErrorInvoiceState(res.data['data']);
      }
    } catch (e) {
      print(e);
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

  Future getInvoiceReport(Map<String, dynamic> data) async {
    try {
      print(data);
      APIMethods obj = APIMethods();
      obj.postData(API.invoice, data).then((res) {
        print(res);
        if (res.data['status'] == "success") {
          emit(InvoiceReportState(res.data!['data']));
        }
      });
    } catch (e) {
      throw ErrorInvoiceState(e.toString());
    }
  }
}
