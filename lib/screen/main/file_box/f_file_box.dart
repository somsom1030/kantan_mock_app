import 'package:flutter/material.dart';
import 'package:kantan_mock_app/screen/main/file_box/w_custom_app_bar.dart';

class FileBoxFragment extends StatefulWidget {
  const FileBoxFragment({super.key});

  @override
  State<FileBoxFragment> createState() => _FileBoxFragmentState();
}

class _FileBoxFragmentState extends State<FileBoxFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          const CustomAppBar(),
        ],
      ),
    );
  }
}
