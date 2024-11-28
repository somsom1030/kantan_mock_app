import 'package:flutter/material.dart';
import 'package:kantan_mock_app/screen/main/file_box/alarm/f_alarm.dart';

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
      color: Colors.white,
      child: Stack(
        children: [
          // 메뉴 드로어 버튼
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                openDrawer(context);
              },
            ),
          ),
          // 이미지 (가운데 정렬)
          Center(
            child: Image.asset(
              'assets/images/title.jpg',
              width: 100,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          // 알림 및 더보기 아이콘
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.notifications, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AlarmFragment()),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    print("click more_vert");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}
