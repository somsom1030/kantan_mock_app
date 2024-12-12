import 'package:flutter/material.dart';
import 'package:kantan_mock_app/common/utility/upload_file_check.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/f_all_file.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/photo_provider.dart';
import 'package:kantan_mock_app/screen/main/file_box/vo/vo_all_file_data.dart';
import 'package:kantan_mock_app/screen/main/w_simple_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

class UploadFragment extends StatefulWidget {
  const UploadFragment({super.key});

  @override
  State<UploadFragment> createState() => _UploadFragmentState();
}

class _UploadFragmentState extends State<UploadFragment> {
  // ScrollControllerを追加して
  final ScrollController _scrollController = ScrollController();
  late List<bool> isCheckedList;

  @override
  void initState() {
    super.initState();
    final uploadList =
        Provider.of<PhotoProvider>(context, listen: false).uploadList;
    isCheckedList = List<bool>.filled(uploadList.length, false); // リセット
  }

  @override
  void dispose() {
    // ScrollController를 dispose하여 메모리를 해제합니다.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("isCheckedList111 : ${isCheckedList.length}");
    final uploadList = Provider.of<PhotoProvider>(context).uploadList;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 248),
      appBar: const SimpleAppBar(title: 'アップロード確認'),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                child: '選択項目数 : ${isCheckedList.length}'
                    .text
                    .size(10)
                    .color(Colors.grey)
                    .make(),
              ),
              Expanded(
                child: uploadList.isEmpty
                    ? const Center(
                        child: Text('No photos available.')) // ファイルがない時
                    : Scrollbar(
                        controller: _scrollController, // ScrollController 連結
                        thumbVisibility: true, // スクロールバー表示
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GridView.builder(
                            controller:
                                _scrollController, // GridViewに ScrollController 追加
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 한 줄에 2개씩
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              childAspectRatio: 1.0, // 정사각형 비율
                            ),
                            itemCount: uploadList.length,
                            itemBuilder: (context, index) {
                              final photo = uploadList[index];
                              final photoFile = photo.filePath;
                              final photoName = photo.fileName;
                              final photoDate = photo.date;
                              final photoType = photo.isFile;
                              print("photo.isFile : ${photo.isFile}");

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18),
                                            child: buildFileWidget(photoType,
                                                file: photoFile),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          photoName,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          '${photoDate.year}-${photoDate.month}-${photoDate.day}',
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    // 修正アイコン
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          // トリミング作業
                                          CroppedFile? croppedFile =
                                              await ImageCropper().cropImage(
                                            sourcePath: photoFile.path,
                                            compressFormat:
                                                ImageCompressFormat.jpg,
                                            compressQuality: 80,
                                            maxWidth: 1000,
                                            maxHeight: 1000,
                                          );

                                          // トリミングされた画像があれば, それを使用する
                                          if (croppedFile != null) {
                                            print(
                                                'Cropped Image Path: ${croppedFile.path}');
                                            File croppedFileAsFile =
                                                File(croppedFile.path);
                                            Provider.of<PhotoProvider>(context,
                                                    listen: false)
                                                .updatePhoto(
                                                    index, croppedFileAsFile);
                                          }
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Checkbox(
                                        value: isCheckedList[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isCheckedList[index] =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
          // 画面の下中央に固定されたボタン
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // 選択されたファイルだけ
                  final selectedPhotos = uploadList
                      .asMap()
                      .entries
                      .where((entry) => isCheckedList[entry.key])
                      .map((entry) => entry.value.filePath)
                      .toList();

                  print('selectedPhotos: $selectedPhotos');

                  // PhotoProviderに選択されたファイル追加
                  Provider.of<PhotoProvider>(context, listen: false)
                      .addFileList(selectedPhotos);
                  Provider.of<PhotoProvider>(context, listen: false)
                      .clearFiles();

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('アップロード'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
