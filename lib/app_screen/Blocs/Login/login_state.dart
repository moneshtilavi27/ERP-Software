import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

/// Initialized
class LoginInitialState extends LoginState {}

/// UnInitialized
class LogoutState extends LoginState {}

/// UnInitialized
class LogInValidState extends LoginState {}

/// UnInitialized
class WrongCredential extends LoginState {}

/// Initialized
class InLoginState extends LoginState {}

class ErrorLoginState extends LoginState {
  ErrorLoginState(this.errorMessage);

  final String errorMessage;

  @override
  String toString() => 'ErrorLoginState';

  @override
  List<Object> get props => [errorMessage];
}

class LoginLoadingState extends LoginState {}
