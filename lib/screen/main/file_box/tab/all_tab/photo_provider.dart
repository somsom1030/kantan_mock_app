import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantan_mock_app/screen/main/file_box/vo/vo_all_file_data.dart';

class PhotoProvider with ChangeNotifier {
  List<AllFile> _fileList = [];
  List<AllFile> get fileList => _fileList;

  List<AllFile> _uploadList = [];
  List<AllFile> get uploadList => _uploadList;

  // アップロード確認画面に送るデータ
  void addFiles(List<File> files) {
    for (var file in files) {
      String fileName = file.path.split('/').last;
      DateTime fileDate = file.lastModifiedSync();

      // Photo 객체 생성 후 리스트에 추가
      _uploadList.add(AllFile(
        filePath: file,
        fileName: fileName,
        date: fileDate,
        isFile: getExtension(fileName).toString(),
      ));
    }

    print('Photo List Count: ${_uploadList.length}');
    notifyListeners(); //リストが変更した時UIアップデート
  }

  // アップデートボタン押下した時メイン画面に送るデータ
  void addFileList(List<File> files) {
    for (var file in files) {
      String fileName = file.path.split('/').last;
      DateTime fileDate = file.lastModifiedSync();

      _fileList.add(AllFile(
        filePath: file,
        fileName: fileName,
        date: fileDate,
        isFile: getExtension(fileName).toString(),
      ));
    }
    print('Photo List Count: ${_fileList.length}');
    notifyListeners();
  }

  // //一つの画像を保存する
  // void addPhoto(File file) {
  //   String fileName = _generateFileName();
  //   DateTime fileDate = file.lastModifiedSync();
  //   _photoList.add(AllFile(
  //     filePath: file,
  //     fileName: fileName,
  //     date: fileDate,
  //     isFile: true,
  //   ));
  //   notifyListeners();
  // }

  // 写真一枚アップデートする
  void updatePhoto(int index, File newFile) {
    AllFile updatedPhoto = _uploadList[index];

    // ファイルパスとファイル名修正
    String newFileName = newFile.path.split('/').last;
    DateTime newFileDate = newFile.lastModifiedSync();

    // 수정된 정보를 반영하여 새로운 AllFile 객체로 업데이트
    _uploadList[index] = AllFile(
      filePath: newFile,
      fileName: newFileName,
      date: newFileDate,
      isFile: getExtension(newFileName),
    );

    notifyListeners();
    print('Updated Photo at index $index');
  }

  // ファイルリストを初期化する
  void clearFiles() {
    _uploadList.clear();
    print('_uploadList Count: ${_uploadList.length}');
    notifyListeners();
  }

  // ファイル名を日時に変更
  String _generateFileName() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return formatter.format(now); // ex: 20231127_153045
  }

  //拡張子
  String getExtension(String fileName) {
    return fileName.split('.').last;
  }
}
