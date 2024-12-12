import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:kantan_mock_app/screen/main/w_simple_app_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class PreviewScreen extends StatefulWidget {
  const PreviewScreen(
      {super.key,
      this.filePath,
      required this.fileName,
      required this.fileDate,
      required this.fileType});

  final dynamic filePath;
  final String fileName;
  final DateTime fileDate;
  final String fileType;

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    print("---------widget.filePath------- : ${widget.filePath}");

    Widget bodyContent;

    // 파일의 타입에 따라 이미지, PDF, 엑셀 파일을 처리
    if (widget.fileType == "png" || widget.fileType == "jpg") {
      // イメージファイルの場合
      bodyContent = _buildImagePreview(widget.filePath);
    } else if (widget.fileType == "xlsx") {
      // エクセルファイルの場合
      print('filePath: ${widget.filePath.path}');
      _openExcelFileAndroid(widget.filePath);
      //_openExcelFile(widget.filePath);
      bodyContent =
          Center(child: CircularProgressIndicator()); // ファイルが開いてる空いたのインディケーター
    } else if (widget.fileType == "pdf") {
      // PDF ファイルの場合
      bodyContent = FutureBuilder<Widget>(
        future: _buildPdfPreview(widget.filePath), // PDF 非同期処理
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('PDF ロード失敗: ${snapshot.error}'));
          } else {
            return snapshot.data ?? const Center(child: Text('PDF ロード失敗'));
          }
        },
      );
    } else {
      bodyContent = Center(child: Text('サポートされていないファイルのタイプ'));
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
        body: bodyContent,
      ),
    );
  }

  // 이미지 파일을 로드하고 확대/축소 기능 추가
  Widget _buildImagePreview(dynamic filePath) {
    try {
      return InteractiveViewer(
        panEnabled: true,
        minScale: 1.0,
        maxScale: 4.0,
        child: Image.file(
          filePath,
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      );
    } catch (e) {
      return Center(child: Text('イメージロード失敗: $e'));
    }
  }

  // PDF 파일을 미리보는 메서드
  Future<Widget> _buildPdfPreview(dynamic filePath) async {
    await requestStoragePermissions(); // 権限リクエスト

    final String file = widget.filePath is File
        ? widget.filePath.path
        : widget.filePath.toString();

    try {
      return PDFView(
        filePath: file, // PDF ファイルパス
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        onError: (e) {
          print(" ロード失敗１: $e");
          setState(() {
            errorMessage = ' ロード失敗１: $e'; // エラーメッセージアップデート
          });
        },
        onPageError: (page, e) {
          print(" ロード失敗２: $e");
          setState(() {
            errorMessage = 'ページ ロード失敗２: $e'; // エラーメッセージアップデート
          });
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'PDF ロード失敗３: $e';
      });
      return Center(child: Text(errorMessage));
    }
  }

  // MANAGE_EXTERNAL_STORAGE 権限リクエスト
  Future<void> requestStoragePermissions() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      print('MANAGE_EXTERNAL_STORAGE 権限成功');
    } else {
      final statusStorage = await Permission.storage.request();
      if (statusStorage.isGranted) {
        print('Storage 権限許可');
      } else {
        print('Storage 権限x');
        if (status.isPermanentlyDenied || statusStorage.isPermanentlyDenied) {
          // 設定画面に繊維
          openAppSettings();
        }
      }
    }
  }

  // エクセルファイル開く
  Future<void> _openExcelFileAndroid(dynamic filePath) async {
    try {
      //final uri = Uri.parse('content://${filePath}');

      print('aaaaaaa');
      String filePathString = widget.filePath.path;

      print('filePathString: ${filePathString}');
      final uri1 = Uri.parse(
          'content://com.example.kantan_mock_app.fileprovider${filePathString}');
      print('URI1: ${uri1.toString()}');

      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: uri1.toString(),
        type:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        flags: [Flag.FLAG_GRANT_READ_URI_PERMISSION],
        package: 'com.microsoft.office.excel',
      );

      print('Intent: ${intent.toString()}');

      await intent.launch();
    } catch (e) {
      setState(() {
        errorMessage = "excel file error: $e";
      });
    }
  }
}
