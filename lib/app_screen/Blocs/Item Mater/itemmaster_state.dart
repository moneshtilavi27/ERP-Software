import 'package:equatable/equatable.dart';

abstract class ItemmasterState extends Equatable {
  ItemmasterState();

  @override
  List<Object> get props => [];
}

/// UnInitialized
class UnItemmasterState extends ItemmasterState {}

/// Initialized
class IntialState extends ItemmasterState {}

class StoreListState extends ItemmasterState {
  final List dataList;

  StoreListState(this.dataList);

  @override
  List<Object> get props => [dataList];
}

class itemListState extends ItemmasterState {
  final List dataList;

  itemListState(this.dataList);

  @override
  List<Object> get props => [dataList];
}

class itemAddUpdateState extends ItemmasterState {}

class ErrorItemmasterState extends ItemmasterState {
  ErrorItemmasterState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorItemmasterState';

  @override
  List<Object> get props => [errorMessage];
}
