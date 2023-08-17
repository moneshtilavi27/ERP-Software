import 'package:erp/service/API/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/API/api_methods.dart';
import 'itemmaster_event.dart';
import 'itemmaster_state.dart';

class ItemmasterBloc extends Bloc<ItemmasterEvent, ItemmasterState> {
  ItemmasterBloc() : super(IntialState()) {
    APIMethods obj = APIMethods();
    featchItemData({'request': "get"});

    on<FeatchItemmasterEvent>((event, emit) async {
      featchItemData({'request': "get", "item_name": "monesh"});
    });

    on<FilterItemEvent>((event, emit) => {
          featchItemData(
              {'request': "getItemNames", "item_name": event.item_name})
        });

    on<AddItemEvent>((event, emit) async {
      APIMethods obj = new APIMethods();
      Map<String, String> data = {
        "request": "add",
        "item_name": event.item_name,
        "item_hsn": event.item_hsn,
        "item_gst": event.item_gst,
        "item_unit": event.item_unit,
        "basic_value": event.basic_value,
        "whole_sale_value": event.basic_value
      };
      await obj.postData(API.itemMaster, data).then((res) async {
        try {
          if (res.data['status'] == "success") {
            print("success");
            emit(itemAddUpdateState());
            featchItemData({'request': "get"});
          } else {
            emit(ErrorItemmasterState(res.data['data']));
            print("fails");
          }
        } catch (e) {
          print(e.toString());
          emit(ErrorItemmasterState(e.toString()));
        }
      }).catchError((error) {
        emit(ErrorItemmasterState(error));
      });
    });
  }

  void featchItemData(Map<String, String> data) async {
    try {
      APIMethods obj = APIMethods();
      Map<String, String> para = data;
      await obj.postData(API.itemMaster, para).then((res) {
        if (res.data['status'] == "success") {
          emit(StoreListState(res.data['data']));
        }
      });
    } catch (e) {
      print(e.toString());
      emit(ErrorItemmasterState(e.toString()));
    }
  }
}
