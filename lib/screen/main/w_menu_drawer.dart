import 'package:flutter/material.dart';
import 'package:kantan_mock_app/common/widget/w_tap.dart';
import 'package:kantan_mock_app/screen/main/file_box/w_custom_app_bar.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("miroku"),
            accountEmail: Text("miroku@mjs.co.jp"),
            onDetailsPressed: () {
              print("on details pressed");
            },
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 91, 150, 250), // 배경색 변경
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("home"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("setting"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void closeDrawer(BuildContext context) {
    if (Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).closeDrawer();
    }
  }
}
