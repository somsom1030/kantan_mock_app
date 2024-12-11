import 'dart:io';
import 'package:flutter/material.dart';

Widget buildFileWidget(String fileType, {File? file}) {
  print('buildFileWidget - fileType: $fileType, file: $file');
  switch (fileType) {
    case "jpg":
    case "png":
      return Image.file(
        file!,
        fit: BoxFit.cover, // 이미지를 뷰에 맞게 잘라서 채우기
        width: 200, // 가로는 부모 크기에 맞추기
        height: 95, // 이미지 세로 크기 고정
      );
    case "pdf":
      return const Center(
        child: Icon(
          Icons.picture_as_pdf_sharp,
          color: Colors.red,
          size: 50, // PDF 아이콘 크기 설정
        ),
      );
    case "xlsx":
      return const Center(
        child: Icon(
          Icons.view_list, // 엑셀에 적합한 아이콘 사용
          color: Colors.green,
          size: 50, // 엑셀 아이콘 크기 설정
        ),
      );
    default:
      return const Center(
        child: Icon(
          Icons.error, // 지원되지 않는 파일 타입 처리
          color: Colors.grey,
          size: 50,
        ),
      );
  }
}
