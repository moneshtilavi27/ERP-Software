import 'package:erp/CommonWidgets/common1.dart';
import 'package:erp/Blocs/Internet/internet_bloc.dart';
import 'package:erp/Blocs/Internet/internet_state.dart';
import 'package:erp/app_screen/Invoice/invoice.dart';
import 'package:erp/app_screen/login.dart';
import 'package:erp/app_screen/report/SalesReport.dart';
import 'package:erp/app_screen/sample.dart';
import 'package:erp/app_screen/second_screen.dart';
import 'package:erp/app_screen/simple_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ItemMaster/ItemMaster.dart';

/// A class for consolidating the definition of menu entries.
///
/// This sort of class is not required, but illustrates one way that defining
/// menus could be done.
class MenuEntry {
  const MenuEntry(
      {required this.label, this.shortcut, this.onPressed, this.menuChildren})
      : assert(menuChildren == null || onPressed == null,
            'onPressed is ignored if menuChildren are provided');
  final String label;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          child: Text(selection.label),
        );
      }
      return MenuItemButton(
        shortcut: selection.shortcut,
        onPressed: selection.onPressed,
        child: Text(selection.label),
      );
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(
      List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result =
        <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] =
              VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}

class MyMenuBar extends StatefulWidget {
  const MyMenuBar({
    super.key,
    required this.message,
  });

  final String message;

  @override
  State<MyMenuBar> createState() => _MyMenuBarState();
}

class _MyMenuBarState extends State<MyMenuBar> {
  ShortcutRegistryEntry? _shortcutsEntry;
  String? _lastSelection;
  Widget _selectedScreens = const Invoice();

  Color get backgroundColor => _backgroundColor;
  Color _backgroundColor = Colors.red;

  set backgroundColor(Color value) {
    if (_backgroundColor != value) {
      setState(() {
        _backgroundColor = value;
      });
    }
  }

  // Create the method to switch screens
  void showScreens(dynamic screens) {
    switch (screens) {
      case SecondScreen:
        {
          setState(() {
            _selectedScreens = const SecondScreen();
          });
        }
        break;

      case SimpleForm:
        {
          setState(() {
            _selectedScreens = const SimpleForm();
          });
        }
        break;
      case Invoice:
        {
          setState(() {
            _selectedScreens = const Invoice();
          });
        }
        break;
      case ItemMaster:
        {
          setState(() {
            _selectedScreens = const ItemMaster();
          });
        }
        break;

      case HomeScreens:
        {
          setState(() {
            _selectedScreens = const HomeScreens();
          });
        }
        break;
      case SalesReport:
        {
          setState(() {
            _selectedScreens = const SalesReport();
          });
        }
        break;

      default:
        {
          //statements;
        }
        break;
    }
  }

  bool get showingMessage => _showMessage;
  bool _showMessage = true;
  set showingMessage(bool value) {
    if (_showMessage != value) {
      setState(() {
        _showMessage = value;
      });
    }
  }

  @override
  void dispose() {
    _shortcutsEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: MenuBar(
                style: MenuStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.blue.shade100),
                ),
                children: MenuEntry.build(_getMenus()),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black, width: 1.0, style: BorderStyle.solid),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: _selectedScreens,
              )),
        ),
      ],
    );
  }

  List<MenuEntry> _getMenus() {
    final List<MenuEntry> result = <MenuEntry>[
      MenuEntry(label: 'Invoie', menuChildren: <MenuEntry>[
        MenuEntry(
          label: 'New',
          onPressed: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => SecondScreen(),
            //   ),
            // );
            showScreens(Invoice);
          },
          shortcut:
              const SingleActivator(LogicalKeyboardKey.keyN, control: true),
        )
      ]),
      MenuEntry(label: 'Master', menuChildren: <MenuEntry>[
        MenuEntry(
          label: 'Item Master',
          onPressed: () {
            showScreens(ItemMaster);
          },
          shortcut:
              const SingleActivator(LogicalKeyboardKey.keyI, control: true),
        )
      ]),
      MenuEntry(label: 'Report', menuChildren: <MenuEntry>[
        MenuEntry(
          label: 'Sales Bill',
          // onPressed: () {
          //   showScreens(SalesReport);
          // },
        ),
        // MenuEntry(
        //   label: 'Sales Item',
        //   onPressed: () {},
        // ),
        // MenuEntry(
        //   label: 'C A Report',
        //   onPressed: () {},
        // )
      ]),
      MenuEntry(
        label: 'Logout',
        onPressed: () async {
          // showScreens(HomeScreens);
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => const Login(),
          //   ),
          // );
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.clear();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
        },
      ),
    ];
    // (Re-)register the shortcuts with the ShortcutRegistry so that they are
    // available to the entire application, and update them if they've changed.
    _shortcutsEntry?.dispose();
    _shortcutsEntry =
        ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    return result;
  }
}

class MenuBarApp extends StatelessWidget {
  const MenuBarApp({super.key});

  static const String kMessage = '"Talk less. Smile more." - A. Burr';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("monu")),
        body: Text("monu"),
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
