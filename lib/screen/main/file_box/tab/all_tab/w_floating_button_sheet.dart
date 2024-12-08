import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/f_upload_file.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/photo_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

class FloatingButtonSheetWidget extends StatelessWidget {
  const FloatingButtonSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                _buildListItem('写真撮影', Icons.camera_alt, () {}),
                _buildListItem('書類アップロード', Icons.file_open, () {}),
                _buildListItem('画像アップロード', Icons.picture_in_picture, () {
                  _pickImage(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        // 선택된 이미지를 PhotoProvider에 추가
        List<File> files = pickedFiles.map((file) => File(file.path)).toList();
        Provider.of<PhotoProvider>(context, listen: false).addPhotos(files);
        Navigator.pop(context); // 선택 후 화면 닫기
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadFragment()),
        );
      }
    } catch (e) {
      print("error: $e");
    }
  }

  // 리스트 항목을 구성하는 위젯
  Widget _buildListItem(String itemText, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 25),
            const SizedBox(width: 15),
            itemText.text.size(20).make(),
          ],
        ),
      ),
    );
  }
}
