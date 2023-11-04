import 'package:erp/Blocs/Internet/internet_bloc.dart';
import 'package:erp/Blocs/Internet/internet_event.dart';
import 'package:erp/Blocs/Login/login_bloc.dart';
import 'package:erp/Blocs/Login/login_state.dart';
import 'package:erp/CommonWidgets/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Blocs/Invoice/invoice_bloc.dart';
import 'Blocs/Item Mater/itemmaster_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter is initialized first.
  final sharedPreferences = await SharedPreferences.getInstance();

  // // Initialize the desktop window
  // await DesktopWindow.setMinWindowSize(Size(
  //     double.infinity, double.infinity)); // Set minimum window size if needed
  // await DesktopWindow.setMaxWindowSize(Size(double.infinity, double.infinity));

  // // Set up window properties
  // await DesktopWindow.setFullScreen(true);
  // await DesktopWindow.toggleFullScreen(); // Disable window resizing

  runApp(Main(sharedPreferences: sharedPreferences));
}

class Main extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const Main({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NetworkBloc()..add(NetworkObserve()),
          ),
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => ItemmasterBloc(),
          ),
          BlocProvider(
            create: (context) => InvoiceBloc(sharedPreferences),
          )
        ],
        child: MaterialApp(
          title: "ERP Software",
          home: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
            return const SplashScreen();
          }),
          // debugShowCheckedModeBanner: false
        )
        // child: MaterialApp(title: "ERP Software", home: HomePage(title: 'ERP')),
        );
  }
}
