// ignore: library_prefixes
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Login/login_bloc.dart';
import 'package:erp/app_screen/Blocs/Login/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp/app_screen/login.dart';
import 'package:erp/app_screen/menu_bar.dart';

import 'Responsive.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemMasterBloc = BlocProvider.of<ItemmasterBloc>(context);

    double defaultMargin;
    if (Responsive.isDesktop(context)) {
      defaultMargin = 600.0;
    } else if (Responsive.isTablet(context)) {
      defaultMargin = 400.0;
    } else {
      defaultMargin = 400.0;
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is InLoginState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MyMenuBar(
                message: 'my menu bar',
              ),
            ),
          );
        }
        if (state is LogoutState) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.amber.shade100, Colors.blue.shade100],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: defaultMargin / 3,
                height: defaultMargin / 3,
                child: const Image(
                  image: AssetImage('lib/service/asset/logo.png'),
                  width: 250,
                  height: 250,
                ),
              ),
              const Padding(padding: EdgeInsets.all(30.0)),
              const Text(
                'Bus Tracking',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  letterSpacing: 0.084,
                  fontWeight: FontWeight.w500,
                  height: 2,
                ),
                textHeightBehavior:
                    TextHeightBehavior(applyHeightToFirstAscent: false),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
