import 'package:equatable/equatable.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnInvoiceState extends InvoiceState {}

/// Initialized
class IntialState extends InvoiceState {}

class InvoiceItemListState extends InvoiceState {
  final List dataList;

  const InvoiceItemListState(this.dataList);

  @override
  List<Object> get props => [dataList];
}

class itemListState extends InvoiceState {
  final List dataList;

  const itemListState(this.dataList);

  @override
  List<Object> get props => [dataList];
}

class itemAddUpdateState extends InvoiceState {}

class ErrorInvoiceState extends InvoiceState {
  const ErrorInvoiceState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorInvoiceState';

  @override
  List<Object> get props => [errorMessage];
}

class InvoiceDataState extends InvoiceState {
  final List dataList;

  const InvoiceDataState(this.dataList);
}

class InvoiceStatus extends InvoiceState {
  final String status;

  const InvoiceStatus(this.status);

  @override
  List<Object> get props => [status];
}
