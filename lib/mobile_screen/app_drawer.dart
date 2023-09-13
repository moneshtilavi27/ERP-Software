import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_bloc.dart';
import 'package:erp/app_screen/Blocs/Internet/internet_state.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_bloc.dart';
import 'package:erp/app_screen/Blocs/Item%20Mater/itemmaster_state.dart';
import 'package:erp/mobile_screen/Users.dart';
import 'package:erp/mobile_screen/bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'UserSearch.dart';

class AppDrawer extends StatefulWidget {
  final String title;

  const AppDrawer({Key? key, required this.title}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  int _selectedIndex = 0;
  late Widget page = Users();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        page = Users();
        break;
      case 1:
        // page = Bucket(title: "Bucket");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Bucket(title: "Bucket")));
        break;
      default:
    }
    setState(() {
      _selectedIndex = 0;
    });
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
        actions: [AppBarActionButton()],
      ),
      body: Center(
        child: page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_outlined),
            label: 'Invoice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Bucket',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
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
    );
  }
}

class AppBarActionButton extends StatelessWidget {
  const AppBarActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemmasterBloc, ItemmasterState>(
        builder: (context, state) {
      if (state is StoreListState) {
        return IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: UserSearch(state.dataList));
          },
        );
      } else {
        return const Text("");
      }
    });
  }
}
