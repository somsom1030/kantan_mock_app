import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? notificationIcon; // 알림 아이콘 커스텀 가능
  final VoidCallback? onNotificationPressed; // 알림 아이콘 동작
  final Widget? settingsIcon; // 설정 아이콘 커스텀 가능
  final VoidCallback? onSettingsPressed; // 설정 아이콘 동작

  const SimpleAppBar({
    Key? key,
    required this.title,
    this.notificationIcon,
    this.onNotificationPressed,
    this.settingsIcon,
    this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Color.fromARGB(244, 49, 49, 49),
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (notificationIcon != null && onNotificationPressed != null)
          IconButton(
            icon: notificationIcon!,
            onPressed: onNotificationPressed,
          ),
        if (settingsIcon != null && onSettingsPressed != null)
          IconButton(
            icon: settingsIcon!,
            onPressed: onSettingsPressed,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
