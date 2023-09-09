import 'package:equatable/equatable.dart';

abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object?> get props => [];
}

class NetworkInitial extends NetworkState {}

class NetworkStatus extends NetworkState {
  final bool status;
  const NetworkStatus(this.status);
}

class NetworkSuccess extends NetworkState {}

class NetworkFailure extends NetworkState {}
