abstract class LoginEvent {}

class TextChangedEvent extends LoginEvent {
  final String usernameValue;
  final String PasswordValue;
  TextChangedEvent(this.usernameValue, this.PasswordValue);
}

class OnSubmitEvent extends LoginEvent {
  final String username;
  final String Password;
  OnSubmitEvent(this.username, this.Password);
}

class OnCheckLogin extends LoginEvent {}
