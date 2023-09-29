import 'package:erp/app_screen/Blocs/Invoice/invoice_bloc.dart';
import 'package:erp/app_screen/Blocs/Invoice/invoice_event.dart';
import 'package:erp/app_screen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(
                    'lib/service/asset/logo.png'), // Add your image asset here
              ),
              const SizedBox(height: 20),
              const Text(
                'Monesh Tilavi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Software Developer',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 5,
              ),
              const ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
                subtitle: Text('+1234567890'),
              ),
              const Divider(
                height: 5,
              ),
              const ListTile(
                leading: Icon(Icons.email),
                title: Text('Email'),
                subtitle: Text('johndoe@example.com'),
              ),
              const Divider(
                height: 5,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Email'),
                onTap: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  // ignore: use_build_context_synchronously
                  BlocProvider.of<InvoiceBloc>(context).add(ClearStateEvent());
                  // sp.clear();
                  // // ignore: use_build_context_synchronously
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => const Login()),
                  //     (route) => false);
                },
              ),
              const Divider(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
