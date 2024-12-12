import 'package:flutter/material.dart';
import 'package:kantan_mock_app/common/widget/w_line.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/f_all_file.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/recently_tab/f_recently_file.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/trash_tab/f_trash_file.dart';
import 'package:kantan_mock_app/screen/main/file_box/w_custom_app_bar.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/w_floating_button_sheet.dart';
import 'package:velocity_x/velocity_x.dart';

class FileBoxFragment extends StatefulWidget {
  const FileBoxFragment({super.key});

  @override
  State<FileBoxFragment> createState() => _FileBoxFragmentState();
}

class _FileBoxFragmentState extends State<FileBoxFragment>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this); // TabController リセット
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      body: Column(
        children: [
          const CustomAppBar(),
          tabBar,
          Expanded(
            // 選択された Fragment 表示
            child: IndexedStack(
              index: currentIndex,
              children: const [
                AllFragment(),
                RecentlyFragment(),
                TrashFragment(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (BuildContext context) {
              return const FloatingButtonSheetWidget();
            },
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget get tabBar => Column(
        children: [
          TabBar(
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 2.5,
                color: Color.fromARGB(255, 48, 162, 255),
              ),
              insets: EdgeInsets.symmetric(horizontal: 60.0),
            ),
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            labelPadding: const EdgeInsets.symmetric(vertical: 20),
            indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
            indicatorColor: Colors.white,
            controller: tabController,
            tabs: const [
              Text('すべて'),
              Text('最近使った項目'),
              Text('ゴミ箱'),
            ],
          ),
          const Line(), // 구분선 위젯
        ],
      );
}
