import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kantan_mock_app/screen/main/file_box/f_file_box.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/photo_provider.dart';
import 'package:kantan_mock_app/screen/main/menu/f_menu.dart';
import 'package:kantan_mock_app/screen/main/search/f_search.dart';
import 'package:kantan_mock_app/screen/main/w_menu_drawer.dart';
import 'package:provider/provider.dart';

void main() {
  // 상단 상태바 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white, // 상태바 배경 흰색
      statusBarIconBrightness: Brightness.dark, // 아이콘 색상 검정
      statusBarBrightness: Brightness.light, // iOS 상태바 대비 설정
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavExample(),
    );
  }
}

class BottomNavExample extends StatefulWidget {
  @override
  State<BottomNavExample> createState() => _BottomNavExampleState();
}

class _BottomNavExampleState extends State<BottomNavExample> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const MenuFragment(),
    const FileBoxFragment(),
    const SearchFragment(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // 상태바 배경 흰색
        statusBarIconBrightness: Brightness.dark, // 아이콘 색상 검정
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: null,
          drawer: const MenuDrawer(),
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
