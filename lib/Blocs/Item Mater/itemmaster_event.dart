abstract class ItemmasterEvent {}

class UnItemmasterEvent extends ItemmasterEvent {}

class LoadItemmasterEvent extends ItemmasterEvent {}

class LoaderEvent extends ItemmasterEvent {}

class FeatchItemmasterEvent extends ItemmasterEvent {
  final String item_name;
  FeatchItemmasterEvent(this.item_name);
}

class FilterItemEvent extends ItemmasterEvent {
  final String item_name;
  FilterItemEvent(this.item_name);
}

class AddItemEvent extends ItemmasterEvent {
  final String barcode;
  final String item_name;
  final String item_hsn;
  final String item_gst;
  final String item_unit;
  final String basic_value;
  final String whole_sale_value;

  AddItemEvent(this.barcode, this.item_name, this.item_hsn, this.item_gst,
      this.item_unit, this.basic_value, this.whole_sale_value);
}

class UpdateItemEvent extends ItemmasterEvent {
  final String item_id;
  final String barcode;
  final String item_name;
  final String item_hsn;
  final String item_gst;
  final String item_unit;
  final String basic_value;
  final String whole_sale_value;

  UpdateItemEvent(this.item_id, this.barcode, this.item_name, this.item_hsn,
      this.item_gst, this.item_unit, this.basic_value, this.whole_sale_value);
}

class DeleteItemEvent extends ItemmasterEvent {
  final String item_id;

  DeleteItemEvent(this.item_id);
}
