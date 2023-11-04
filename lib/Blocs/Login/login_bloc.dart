import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/API/api.dart';
import '../../service/API/api_methods.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  late SharedPreferences sp;
  LoginBloc() : super(LoginInitialState()) {
    checkLogin();

    on<TextChangedEvent>((event, emit) {
      if (event.usernameValue == "") {
        emit(ErrorLoginState("Please enter username."));
      } else if (event.PasswordValue == "") {
        emit(ErrorLoginState("Please enter password"));
      } else {
        emit(LogInValidState());
      }
    });

    on<OnSubmitEvent>((event, emit) async {
      // emit(LoginLoadingState());
      // var map = {};
      // map["phone"] = event.mobile;
      // map["password"] = event.Password;
      APIMethods obj = APIMethods();
      Map<String, String> data = {
        "username": event.username,
        "password": event.Password
      };
      await obj.postData(API.localLogin, data).then((res) async {
        try {
          emit(LoginInitialState());
          SharedPreferences sp = await SharedPreferences.getInstance();
          if (res.data['status'] == "success") {
            sp.setString("auth_key", res.data['accessToken']);
            sp.setString("user_id", res.data['user_id']);
            sp.setString("user_type", res.data['user_type']);
            print(res.data);
            emit(InLoginState());
          } else {
            emit(WrongCredential());
          }
        } catch (e) {
          print(e.toString());
          emit(ErrorLoginState(e.toString()));
        }
      }).catchError((error) {
        emit(ErrorLoginState(error));
      });

      // await postObj.postData("/login", map).then((value) async {
      //   try {
      //     sp = await SharedPreferences.getInstance();

      //     sp.setString("auth_key", value.data['accessToken']);
      //     sp.setString("user", value.data['data']['userType']);
      //     emit(LoggedInState());
      //     switch (value.data['data']['userType']) {
      //       case "Admin":
      //         emit(AdminLoggedInState());
      //         break;
      //       case "Parent":
      //         emit(ParentLoggedInState());
      //         break;
      //       case "Driver":
      //         emit(DriverLoggedInState());
      //         break;
      //       default:
      //         emit(LoggedOutState());
      //         break;
      //     }
      //   } catch (e) {
      //     emit(LoginErrorState("Wring Creadential"));
      //   }
      //   emit(InLoginState());
      // }).catchError((err) {
      //   String errorMessage = err.toString();
      //   String requiredMessage = errorMessage.substring(
      //       errorMessage.indexOf('{message: ') + 10, errorMessage.indexOf('}'));
      //   emit(LoginErrorState(requiredMessage));
      // });

      // response.then((value) async {
      //   try {
      //     await SharedPreferences.getInstance();
      //     value.stream.transform(utf8.decoder).listen((data) {
      //       final jsonMap = json.decode(data);
      //       sp.setString("auth_key", jsonMap['accessToken']);
      //       sp.setString("user", jsonMap['data']['userType']);
      //       emit(LoggedInState());
      //     });
      //   } catch (e) {
      //     emit(LoginErrorState("Wring Creadential"));
      //   }
      // });
    });
  }

  void checkLogin() async {
    sp = await SharedPreferences.getInstance();
    try {
      print("page change");
      String auth = sp.getString("auth_key") ?? "";
      print(sp.getString("user_id"));
      if (auth.isNotEmpty) {
        emit(InLoginState());
      } else {
        emit(LogoutState());
      }
    } catch (e) {
      print(e);
    }
  }
}
