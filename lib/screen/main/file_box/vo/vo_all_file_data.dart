import 'dart:io';

class AllFile {
  final File filePath; // ファイルパス
  final String fileName; // ファイル名
  final DateTime date; // アップロード日時
  final String isFile; //イメージかファイルか

  AllFile({
    required this.filePath,
    required this.fileName,
    required this.date,
    required this.isFile,
  });
}
