import 'package:flutter/material.dart';
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
  // ScrollController를 추가하여 스크롤 상태를 관리합니다.
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    // ScrollController를 dispose하여 메모리를 해제합니다.
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photoList = Provider.of<PhotoProvider>(context).photoList;

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
                child: '選択項目数 : ${photoList.length}'
                    .text
                    .size(10)
                    .color(Colors.grey)
                    .make(),
              ),
              Expanded(
                child: photoList.isEmpty
                    ? const Center(
                        child: Text('No photos available.')) // 비어 있을 때 메시지 표시
                    : Scrollbar(
                        controller: _scrollController, // ScrollController 연결
                        thumbVisibility: true, // 스크롤바 항상 표시
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GridView.builder(
                            controller:
                                _scrollController, // GridView에 ScrollController 추가
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 한 줄에 2개씩
                              crossAxisSpacing: 12.0,
                              mainAxisSpacing: 12.0,
                              childAspectRatio: 1.0, // 정사각형 비율
                            ),
                            itemCount: photoList.length,
                            itemBuilder: (context, index) {
                              final photo = photoList[index];
                              final photoFile = photo.filePath;
                              final photoName = photo.fileName;
                              final photoDate = photo.date;

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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.file(
                                              photoFile,
                                              fit: BoxFit
                                                  .cover, // 이미지를 뷰에 맞게 잘라서 채우기
                                              width: double
                                                  .maxFinite, // 가로는 부모 크기에 맞추기
                                              height: 100, // 이미지 세로 크기 고정
                                            ),
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
                                    // 수정 아이콘 (오른쪽 아래)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () async {
                                          // 이미지 자르기 작업 수행
                                          CroppedFile? croppedFile =
                                              await ImageCropper().cropImage(
                                            sourcePath:
                                                photoFile.path, // 원본 이미지 경로
                                            compressFormat: ImageCompressFormat
                                                .jpg, // 압축 형식
                                            compressQuality:
                                                80, // 압축 품질 (0~100)
                                            maxWidth: 1000, // 최대 가로 크기
                                            maxHeight: 1000, // 최대 세로 크기
                                          );

                                          // 자른 이미지가 있다면, 이를 업데이트하거나 사용
                                          if (croppedFile != null) {
                                            print(
                                                'Cropped Image Path: ${croppedFile.path}');
                                            // 자른 이미지 경로를 사용하여 업데이트 작업을 진행합니다.
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
          // 화면 하단 중앙에 고정된 버튼
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  final newPhotos = List<File>.from(
                      photoList.map((allFile) => allFile.filePath));
                  Provider.of<PhotoProvider>(context, listen: false)
                      .addPhotos(newPhotos);
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
