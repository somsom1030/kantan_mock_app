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
    return Material(child: SafeArea(
      child: Tap(
        onTap: () {
          closeDrawer(context);
        },
      ),
    ));
  }

  void closeDrawer(BuildContext context) {
    if (Scaffold.of(context).isDrawerOpen) {
      Scaffold.of(context).closeDrawer();
    }
  }
}
