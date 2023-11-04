import 'package:erp/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/Blocs/Invoice/invoice_event.dart';
import 'package:erp/app_screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  void _logout() {
    // Implement your logout logic here
    // For example, clear user session, navigate to login screen, etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Information'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('lib/service/asset/logo.png'),
                // Update with your image asset path
              ),
              SizedBox(height: 20),
              Text(
                'ERP Software', // Replace with your app name
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Version 1.0', // Replace with your app version
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Divider(
                height: 5,
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Contact Us'),
                subtitle: Text(
                    'contact@believebond.com'), // Replace with your contact email
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.web),
                title: Text('Visit Website'),
                subtitle: Text(
                    'https://believebond.com'), // Replace with your website URL
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About Us'),
                subtitle: Text(
                    'We Develop customise software.'), // Replace with your app description
              ),
              Divider(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  BlocProvider.of<InvoiceBloc>(context).add(ClearStateEvent());
                  // sp.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const Login()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
