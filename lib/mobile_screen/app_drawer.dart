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
        actions: const [AppBarActionButton()],
      ),
      body: Center(
        // child: Text(
        //   'A drawer is an invisible side screen.',
        //   style: TextStyle(fontSize: 20.0),
        // )
        child: page,
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: const EdgeInsets.all(0),
      //     children: [
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.green,
      //         ),
      //         child: UserAccountsDrawerHeader(
      //           decoration: BoxDecoration(color: Colors.green),
      //           accountName: Text(
      //             "Monesh Tilavi",
      //             style: TextStyle(fontSize: 18),
      //           ),
      //           accountEmail: Text("moneshitlavi@gmail.com"),
      //           currentAccountPictureSize: Size.square(50),
      //           currentAccountPicture: CircleAvatar(
      //             backgroundColor: Color.fromARGB(255, 165, 255, 137),
      //             child: Text(
      //               "M",
      //               style: TextStyle(fontSize: 30.0, color: Colors.blue),
      //             ),
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.person),
      //         title: const Text(' My Profile '),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.book),
      //         title: const Text(' My Course '),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.workspace_premium),
      //         title: const Text(' Go Premium '),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.logout),
      //         title: const Text('LogOut'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
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
        selectedItemColor: Colors.amber[800],
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
