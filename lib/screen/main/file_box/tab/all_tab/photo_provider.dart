import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 및 시간 포맷을 위한 패키지

class PhotoProvider with ChangeNotifier {
  // 선택된 사진과 해당 이름을 저장할 리스트
  List<Map<String, dynamic>> _photos = [];

  List<Map<String, dynamic>> get photos => _photos;

  // 사진과 이름을 추가하는 함수
  void addPhoto(File photo) {
    // 현재 날짜와 시간을 "yyyyMMdd_HHmmss" 형식으로 생성
    String fileName = _generateFileName();

    // 사진과 이름을 Map 형태로 저장
    _photos.add({
      'file': photo,
      'name': fileName,
    });

    notifyListeners(); // 상태 변화 알리기
  }

  // 사진 이름을 현재 날짜와 시간으로 생성
  String _generateFileName() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyyMMdd_HHmmss');
    return formatter.format(now); // 예: 20231127_153045
  }
}
