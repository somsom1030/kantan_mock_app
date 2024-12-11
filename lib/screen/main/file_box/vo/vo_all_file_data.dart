import 'dart:io';

class AllFile {
  final File filePath; // 이미지 파일
  final String fileName; // 이미지 이름
  final DateTime date; // 이미지 날짜
  final String isFile;

  AllFile({
    required this.filePath,
    required this.fileName,
    required this.date,
    required this.isFile,
  });
}
