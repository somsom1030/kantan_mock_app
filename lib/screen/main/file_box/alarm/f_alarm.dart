import 'package:flutter/material.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/photo_provider.dart';
import 'package:kantan_mock_app/screen/main/w_simple_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

class AlarmFragment extends StatefulWidget {
  const AlarmFragment({super.key});

  @override
  State<AlarmFragment> createState() => _AlarmFragmentState();
}

class _AlarmFragmentState extends State<AlarmFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: const SimpleAppBar(title: '通知'),
      body: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: 'ファイルBOX'.text.size(18).bold.make(),
          ),
        ],
      ),
    );
  }
}
