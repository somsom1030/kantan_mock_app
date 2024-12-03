import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kantan_mock_app/screen/main/file_box/vo/vo_all_file_data.dart'; // 날짜 및 시간 포맷을 위한 패키지

class PhotoProvider with ChangeNotifier {
  List<AllFile> _photoList = [];
  List<AllFile> get photoList => _photoList;

  List<AllFile> _uploadList = [];
  List<AllFile> get uploadList => _uploadList;

  // 사진과 이름을 추가하는 함수
  void addPhotos(List<File> files) {
    for (var file in files) {
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
    print('Photo List Count: ${_photoList.length}'); // 리스트 상태 출력
    notifyListeners(); // 상태 변화 알리기
  }

  // void add(List<File> files) {
  //   for (var file in files) {
  //     String fileName = _generateFileName();
  //     DateTime fileDate = file.lastModifiedSync();
  //     // Photo 객체 생성 후 리스트에 추가
  //     _photoList.add(AllFile(
  //       filePath: file,
  //       fileName: fileName,
  //       date: fileDate,
  //       isFile: true,
  //     ));
  //   }
  //   print('Photo List Count: ${_photoList.length}'); // 리스트 상태 출력
  //   notifyListeners(); // 상태 변화 알리기
  // }

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

  // 사진 한 장 수정하는 메서드
  void updatePhoto(int index, File newFile) {
    AllFile updatedPhoto = _photoList[index];

    // 새로운 파일로 수정하기 (파일 경로와 이름 갱신)
    String newFileName = _generateFileName();
    DateTime newFileDate = newFile.lastModifiedSync();

    // 수정된 정보를 반영하여 새로운 AllFile 객체로 업데이트
    _photoList[index] = AllFile(
      filePath: newFile,
      fileName: newFileName,
      date: newFileDate,
      isFile: true,
    );

    notifyListeners(); // 리스트 변경 시 UI 업데이트
    print('Updated Photo at index $index');
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
