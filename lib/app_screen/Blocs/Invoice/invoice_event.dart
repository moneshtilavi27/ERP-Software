abstract class InvoiceEvent {}

class UnInvoiceEvent extends InvoiceEvent {}

class LoadInvoiceEvent extends InvoiceEvent {}

class CustomerDetailEvent extends InvoiceEvent {
  final String customerName;
  final String customerNumber;
  final String customerAddress;
  CustomerDetailEvent(
      this.customerName, this.customerNumber, this.customerAddress);
}

class FeatchInvoiceEvent extends InvoiceEvent {
  final String item_name;
  FeatchInvoiceEvent(this.item_name);
}

class FilterItemEvent extends InvoiceEvent {
  final String item_name;
  FilterItemEvent(this.item_name);
}

class AddItemEvent extends InvoiceEvent {
  final String item_id;
  final String item_name;
  final String item_hsn;
  final String item_gst;
  final String item_quant;
  final String item_unit;
  final String basic_value;
  final String value;

  AddItemEvent(
    this.item_id,
    this.item_name,
    this.item_hsn,
    this.item_gst,
    this.item_quant,
    this.item_unit,
    this.basic_value,
    this.value,
  );
}

class UpdateItemEvent extends InvoiceEvent {
  final String item_id;
  final String item_name;
  final String item_hsn;
  final String item_gst;
  final String item_quant;
  final String item_unit;
  final String basic_value;
  final String value;

  UpdateItemEvent(this.item_id, this.item_name, this.item_hsn, this.item_gst,
      this.item_quant, this.item_unit, this.basic_value, this.value);
}

class DeleteItemEvent extends InvoiceEvent {
  final String item_id;

  DeleteItemEvent(this.item_id);
}

class PrintBill extends InvoiceEvent {
  final String customerName;
  final String customerNumber;
  final String customerAddress;
  final String status;
  PrintBill(this.customerName, this.customerNumber, this.customerAddress,
      this.status);
}

class CancelBill extends InvoiceEvent {}
