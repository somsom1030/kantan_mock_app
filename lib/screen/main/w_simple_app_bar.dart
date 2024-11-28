import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const SimpleAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(244, 49, 49, 49)),
      ),
      centerTitle: true, // 제목을 가운데 정렬
      backgroundColor: Colors.white, // 배경색 흰색
      elevation: 0, // 그림자 없애기
      iconTheme: const IconThemeData(color: Colors.black), // 아이콘 색상 변경
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // AppBar 높이
}
