import 'dart:io';

import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_bloc.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_state.dart';
import 'package:erp/app_screen/menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp/app_screen/Blocs/Login/login_bloc.dart';
import 'package:erp/app_screen/Blocs/Login/login_event.dart';
import 'package:erp/app_screen/Blocs/Login/login_state.dart';
import 'package:erp/CommonWidgets/Button.dart';
import 'package:erp/CommonWidgets/CustomSnackbar.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:erp/mobile_screen/home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String errorMsg;
  CustomSnackbar showMsg = CustomSnackbar();
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    errorMsg = '';
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // TODO: Implement listener
      },
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/service/asset/background.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: SizedBox(
              width: 360,
              height: 530,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 255, 255, 255).withOpacity(1.0),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: 150,
                          margin: const EdgeInsets.fromLTRB(8, 35, 8, 8),
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('lib/service/asset/logo.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.amber,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            child: TextBox(
                              helpText: "User Name",
                              controller: _usernameController,
                              validator: _validateUsername, // Validate username
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                            child: TextBox(
                              helpText: "Password",
                              controller: _passwordController,
                              isPassword: true,
                              suffixIcon: Icons.visibility_off,
                              validator: _validatePassword, // Validate password
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is InLoginState) {
                                _usernameController.text = '';
                                _passwordController.text = '';
                                if (Platform.isAndroid) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const HomePage(title: "ERP"),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const MyMenuBar(
                                        message: 'my menu bar',
                                      ),
                                    ),
                                  );
                                }
                              }
                              if (state is WrongCredential) {
                                setState(() {
                                  errorMsg = state.errorMessage;
                                });
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                children: [
                                  Button(
                                    onPress: () {
                                      if (_formKey.currentState!.validate()) {
                                        BlocProvider.of<LoginBloc>(context).add(
                                          OnSubmitEvent(
                                            _usernameController.text,
                                            _passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                                    btnColor: Colors.orange,
                                    textColor: Colors.white,
                                    btnText: 'Submit',
                                  ),
                                  Text(
                                    errorMsg,
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomSheet: BlocBuilder<NetworkBloc, NetworkState>(
          builder: (context, state) {
            if (state is NetworkFailure) {
              return InternetStatusMessage(
                isConnected: false,
              );
            } else if (state is NetworkSuccess) {
              return InternetStatusMessage(
                isConnected: true,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
