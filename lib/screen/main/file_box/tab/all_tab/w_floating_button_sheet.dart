import 'dart:io';

import 'package:flutter/material.dart';
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
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Provider.of<PhotoProvider>(context, listen: false)
            .addPhoto(File(image.path));
        Navigator.pop(context);
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
