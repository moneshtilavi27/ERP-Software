import 'package:erp/app_screen/Blocs/Login/login_bloc.dart';
import 'package:erp/app_screen/Blocs/Login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:erp/CommonWidgets/TextBox.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CommonWidgets/Button.dart';
import '../CommonWidgets/CustomSnackbar.dart';
import 'Blocs/Login/login_event.dart';
import 'menu_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  CustomSnackbar showMsg = CustomSnackbar();
  late final TextEditingController _usernameController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();

  Future<List> fetchSimpleData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    List list = <dynamic>[];
    // create a list from the text input of three items
    // to mock a list of items from an http call
    list.add('Test' ' Item 1');
    list.add('Test' ' Item 2');
    list.add('Test' ' Item 3');
    return list;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  // callAPI() {
  //   APIMethods obj = new APIMethods();

  //   obj.getData(API.animal, {}).then((res) {
  //     print(res);
  //   }).catchError((error) {
  //     print(error);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is ErrorLoginState) {
              ScaffoldMessenger.of(context).showSnackBar(showMsg.showSnackbar(
                  Colors.amber, Colors.amber, state.errorMessage));
            }
          },
          child: DecoratedBox(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1578916171728-46686eac8d58?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmV0YWlsJTIwc3RvcmV8ZW58MHx8MHx8fDA%3D&w=1000&q=80"),
                  fit: BoxFit.fill),
            ),
            child: Center(
              child: SizedBox(
                width: 360,
                height: 520,
                child: Container(
                  decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 255, 255, 255).withOpacity(1.0),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid)),
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: 150,
                          margin: const EdgeInsets.fromLTRB(8, 35, 8, 8),
                          decoration: BoxDecoration(
                              // image: DecorationImage(
                              //     image: NetworkImage(
                              //         "https://picsum.photos/id/237/200/300"),
                              //     fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.amber),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: SizedBox(
                        //       child: SearchBox(
                        //     helpText: "User Name",
                        //     controller: _itemController,
                        //     // onChange: (val) {
                        //     //   BlocProvider.of<LoginBloc>(context).add(
                        //     //       TextChangedEvent(_usernameController.text,
                        //     //           _passwordController.text));
                        //     // },
                        //   )),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              child: TextBox(
                            helpText: "User Name",
                            controller: _usernameController,
                            onChange: (val) {
                              BlocProvider.of<LoginBloc>(context).add(
                                  TextChangedEvent(_usernameController.text,
                                      _passwordController.text));
                            },
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                              child: TextBox(
                            helpText: "Password",
                            controller: _passwordController,
                            isPassword: true,
                            suffixIcon: Icons.visibility_off,
                            onChange: (val) {
                              BlocProvider.of<LoginBloc>(context).add(
                                  TextChangedEvent(_usernameController.text,
                                      _passwordController.text));
                            },
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is InLoginState) {
                                _usernameController.text = '';
                                _passwordController.text = '';
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const MyMenuBar(
                                      message: 'my menu bar',
                                    ),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return Button(
                                onPress: () {
                                  // callAPI();
                                  try {
                                    BlocProvider.of<LoginBloc>(context).add(
                                        OnSubmitEvent(_usernameController.text,
                                            _passwordController.text));
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                btnColor: Colors.orange,
                                textColor: Colors.white,
                                btnText: 'Submit',
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
      ),
    );
  }
}
