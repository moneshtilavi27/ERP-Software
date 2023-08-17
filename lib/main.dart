import 'package:desktop_window/desktop_window.dart';
import 'package:erp/app_screen/Blocs/Login/login_bloc.dart';
import 'package:erp/app_screen/Blocs/Login/login_state.dart';
import 'package:erp/CommonWidgets/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_screen/Blocs/Item Mater/itemmaster_bloc.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // // Initialize the desktop window
  // await DesktopWindow.setMinWindowSize(Size(
  //     double.infinity, double.infinity)); // Set minimum window size if needed
  // await DesktopWindow.setMaxWindowSize(Size(double.infinity, double.infinity));

  // // Set up window properties
  // await DesktopWindow.setFullScreen(true);
  // await DesktopWindow.toggleFullScreen(); // Disable window resizing

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => ItemmasterBloc(),
          )
        ],
        child: MaterialApp(
            title: "ERP Software",
            home: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return const SplashScreen();
            })));
  }
}
