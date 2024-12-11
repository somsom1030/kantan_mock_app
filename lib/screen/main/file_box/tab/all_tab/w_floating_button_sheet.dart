import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
      height: MediaQuery.of(context).size.height * 0.2,
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
                _buildListItem('書類アップロード', Icons.file_open, () {
                  _pickFile(context);
                }),
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

  // 파일 선택 다이얼로그
  Future<void> _pickFile(BuildContext context) async {
    try {
      // 파일 선택 다이얼로그 열기
      FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
          type: FileType.custom, // 커스텀 파일 타입 필터
          allowedExtensions: ['pdf', 'xlsx', 'xls'], // PDF, Excel 파일만
          allowMultiple: true // 복수 파일 선택 허용
          );

      if (pickedFiles != null) {
        print(pickedFiles);
        // 선택된 파일 가져오기
        List<File> files = [];
        for (var platformFile in pickedFiles.files) {
          if (platformFile.path != null) {
            files.add(File(platformFile.path!));

            print("파일 경로가 유효: ${platformFile.name}");

            // Provider에 추가
            Provider.of<PhotoProvider>(context, listen: false).addFiles(files);
          } else {
            print("파일 경로가 유효하지 않습니다: ${platformFile.name}");
          }
        }

        // 다이얼로그 닫기
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadFragment()),
        );
      } else {
        // 사용자가 파일 선택을 취소한 경우
        print("파일 선택 취소");
      }
    } catch (e) {
      print("파일 선택 중 오류 발생: $e");
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final List<XFile>? pickedImages = await _picker.pickMultiImage();
      if (pickedImages != null) {
        // 선택된 이미지를 PhotoProvider에 추가
        List<File> files = pickedImages.map((file) => File(file.path)).toList();

        Provider.of<PhotoProvider>(context, listen: false).addFiles(files);

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
