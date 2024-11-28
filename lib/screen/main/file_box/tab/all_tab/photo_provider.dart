import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantan_mock_app/screen/main/file_box/vo/vo_all_file_data.dart'; // 날짜 및 시간 포맷을 위한 패키지

class PhotoProvider with ChangeNotifier {
  // 선택된 사진과 해당 이름을 저장할 리스트
  List<AllFile> _photoList = [];

  List<AllFile> get photoList => _photoList;

  // 사진과 이름을 추가하는 함수
  void addPhotos(List<File> files) {
    for (var file in files) {
// 현재 날짜와 시간을 "yyyyMMdd_HHmmss" 형식으로 생성
      String fileName = _generateFileName();
      DateTime fileDate = file.lastModifiedSync();
      // Photo 객체 생성 후 리스트에 추가
      _photoList.add(AllFile(
        filePath: file,
        fileName: fileName,
        date: fileDate,
        isFile: true,
      ));
    }

    notifyListeners(); // 상태 변화 알리기
  }

  // 하나의 이미지를 추가하는 메서드
  void addPhoto(File file) {
    String fileName = _generateFileName();
    DateTime fileDate = file.lastModifiedSync(); // 파일의 마지막 수정 시간을 날짜로 설정

    _photoList.add(AllFile(
      filePath: file,
      fileName: fileName,
      date: fileDate,
      isFile: true,
    ));
    notifyListeners(); // 리스트 변경 시 UI 업데이트
  }

  // 사진 리스트를 초기화하는 메서드 (필요시 사용)
  void clearPhotos() {
    _photoList.clear();
    notifyListeners(); // 리스트 초기화 시 UI 업데이트
  }

  // 사진 이름을 현재 날짜와 시간으로 생성
  String _generateFileName() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return formatter.format(now); // 예: 20231127_153045
  }
}
