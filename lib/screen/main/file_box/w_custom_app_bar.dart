import 'package:flutter/material.dart';
import 'package:kantan_mock_app/common/widget/w_height_and_width.dart';

class CustomAppBar extends StatefulWidget {
  static const double appBarHeight = 60;
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: CustomAppBar.appBarHeight,
      color: const Color.fromARGB(255, 48, 162, 255),
      child: Row(
        children: [
          width10,
          IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                openDrawer(context);
              }),
          Expanded(child: Container()),
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    print('click Notifications');
                  }),
              Positioned.fill(
                  child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
                ),
              ))
            ],
          ),
          width10,
          IconButton(
              icon: const Icon(Icons.more_horiz),
              onPressed: () {
                print('click more_horiz');
              }),
          width10
        ],
      ),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}
