import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:kantan_mock_app/screen/main/w_simple_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path; // path.join용

class PreviewScreen extends StatefulWidget {
  const PreviewScreen(
      {super.key,
      this.filePath,
      required this.fileName,
      required this.fileDate,
      required this.fileType});

  final dynamic filePath; // 파일 경로
  final String fileName; // 파일 이름
  final DateTime fileDate; // 파일 날짜
  final String fileType; // 파일 유형

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String errorMessage = ''; // 오류 메시지 변수

  @override
  Widget build(BuildContext context) {
    print("---------widget.filePath------- : ${widget.filePath}");

    // 파일 타입에 따라 처리할 위젯을 반환하는 방식으로 수정
    Widget bodyContent;

    // 파일의 타입에 따라 이미지, PDF, 엑셀 파일을 처리
    if (widget.fileType == "png" || widget.fileType == "jpg") {
      // 이미지 파일인 경우
      bodyContent = _buildImagePreview(widget.filePath);
    } else if (widget.fileType == "xlsx") {
      // 엑셀 파일인 경우, 바로 엑셀 파일을 엽니다.
      print('filePath: ${widget.filePath.path}');
      _openExcelFileAndroid(widget.filePath);
      //_openExcelFile(widget.filePath);
      bodyContent = Center(child: CircularProgressIndicator()); // 파일이 열리는 동안 표시
    } else if (widget.fileType == "pdf") {
      // PDF 파일인 경우
      bodyContent = FutureBuilder<Widget>(
        future: _buildPdfPreview(widget.filePath), // PDF 처리 비동기
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('PDF 로딩 실패: ${snapshot.error}'));
          } else {
            return snapshot.data ?? const Center(child: Text('PDF 로딩 실패'));
          }
        },
      );
    } else {
      // 파일 타입이 다른 경우
      bodyContent = Center(child: Text('지원하지 않는 파일 유형입니다.'));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 248, 248, 248),
        appBar: SimpleAppBar(
          title: widget.fileName,
          notificationIcon: const Icon(Icons.upload),
          onNotificationPressed: () {
            print("Upload button pressed");
          },
          settingsIcon: const Icon(Icons.search),
          onSettingsPressed: () {
            print("Search button pressed");
          },
        ),
        body: bodyContent, // 위에서 결정된 bodyContent를 반환
      ),
    );
  }

  // 이미지 파일을 로드하고 확대/축소 기능 추가
  Widget _buildImagePreview(dynamic filePath) {
    try {
      return InteractiveViewer(
        panEnabled: true, // 드래그 활성화
        minScale: 1.0, // 최소 축소 배율
        maxScale: 4.0, // 최대 확대 배율
        child: Image.file(
          filePath,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      );
    } catch (e) {
      return Center(child: Text('이미지 로딩 실패: $e'));
    }
  }

  // PDF 파일을 미리보는 메서드
  Future<Widget> _buildPdfPreview(dynamic filePath) async {
    await requestStoragePermissions(); // 권한 요청

    final String file = widget.filePath is File
        ? widget.filePath.path
        : widget.filePath.toString();

    try {
      return PDFView(
        filePath: file, // PDF 파일 경로
        autoSpacing: true, // 자동 간격 조정
        pageFling: true, // 페이지 넘기기 효과
        pageSnap: true, // 페이지 스냅
        defaultPage: 0, // 기본 페이지 번호
        onError: (e) {
          print("PDF 로딩 오류: $e");
          setState(() {
            errorMessage = 'PDF 로딩 실패: $e'; // 오류 메시지 업데이트
          });
        },
        onPageError: (page, e) {
          print("페이지 로딩 오류: $e");
          setState(() {
            errorMessage = '페이지 로딩 실패: $e'; // 오류 메시지 업데이트
          });
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'PDF 로딩 실패: $e'; // 오류 메시지 업데이트
      });
      return Center(child: Text(errorMessage));
    }
  }

  // MANAGE_EXTERNAL_STORAGE 권한을 요청하는 예시
  Future<void> requestStoragePermissions() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      print('MANAGE_EXTERNAL_STORAGE 권한 허가됨');
    } else {
      final statusStorage = await Permission.storage.request(); // 추가적인 권한 요청
      if (statusStorage.isGranted) {
        print('Storage 권한 허가됨');
      } else {
        print('Storage 권한 거부됨');
        if (status.isPermanentlyDenied || statusStorage.isPermanentlyDenied) {
          // 권한 거부 시 설정 화면으로 이동
          openAppSettings();
        }
      }
    }
  }

  // 엑셀 파일 열기
  Future<void> _openExcelFileAndroid(dynamic filePath) async {
    try {
      //final uri = Uri.parse('content://${filePath}');

      print('aaaaaaa');
      String filePathString = widget.filePath.path; // 파일 경로 추출

      print('filePathString: ${filePathString}');
      final uri1 = Uri.parse(
          'content://com.example.kantan_mock_app.fileprovider${filePathString}');
      print('URI1: ${uri1.toString()}'); // 이 부분 출력 확인

      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: uri1.toString(),
        type:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // MIME 타입
        flags: [Flag.FLAG_GRANT_READ_URI_PERMISSION],
        package: 'com.microsoft.office.excel',
      );

      print('Intent: ${intent.toString()}');

      await intent.launch();
    } catch (e) {
      setState(() {
        errorMessage = "엑셀 파일 열기 중 오류 발생: $e";
      });
    }
  }

  // 엑셀 파일 열기
  Future<void> _openExcelFile(dynamic filePath) async {
    try {
      if (filePath is File) {
        final String filePathString = filePath.path;
        final uri = Uri.parse(
            'content://com.example.kantan_mock_app.fileprovider${filePathString}');

        final intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: uri.toString(),
          package: 'com.microsoft.office.excel', // 엑셀 앱 패키지 이름
          type:
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // 엑셀 파일 MIME 타입
        );
        await intent.launch();
      } else {
        throw Exception("유효하지 않은 파일 경로");
      }
    } catch (e) {
      print("엑셀 파일 열기 중 오류: $e");
    }
  }
}
