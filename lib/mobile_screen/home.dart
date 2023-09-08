import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_bloc.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_state.dart';
import 'package:erp/mobile_screen/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_drawer.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late var page;

  final List<Map<String, dynamic>> _items = [
    {
      'name': 'Invoice',
      'icon': Icons.inventory_outlined,
    },
    {
      'name': 'Setting',
      'icon': Icons.settings,
    }
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigate(String Screen) {
    switch (Screen) {
      case "Invoice":
        // page = AppDrawer(title: "Invoice");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AppDrawer(title: "Invoice")));
        break;
      case "Setting":
        // page = ProfileScreen();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        itemCount: _items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.all(30.0),
            child: InkWell(
              onTap: () {
                _navigate(_items[index]['name']);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_items[index]['icon'], size: 45),
                  const SizedBox(height: 2.0),
                  Text(_items[index]['name'],
                      style: const TextStyle(fontSize: 14.0)),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            if (index == 0) {
              print(index);
              // _navigate("Invoice");
            } else {
              _navigate("Setting");
            }
          }),
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
          // return InternetStatusMessage(
          //   isConnected: (state is NetworkStatus) && state.status,
          // );
        },
      ),
    );
  }
}
