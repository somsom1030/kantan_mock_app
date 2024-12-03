import 'package:flutter/material.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/photo_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';

class AllFragment extends StatefulWidget {
  const AllFragment({super.key});

  @override
  State<AllFragment> createState() => _AllFragmentState();
}

class _AllFragmentState extends State<AllFragment> {
  bool _isGridView = false; // 현재 뷰 상태를 저장 (리스트 뷰 또는 그리드 뷰)
  List<XFile> _pickedImgs = [];

  @override
  Widget build(BuildContext context) {
    final photoList = Provider.of<PhotoProvider>(context).photoList;

    return SingleChildScrollView(
      // 전체 화면 스크롤을 가능하게 함
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: 'ファイルBOX'.text.size(18).bold.make(),
          ),
          sortBox(context),
          Padding(
            padding: const EdgeInsets.all(
                16.0), // Padding을 ListView와 GridView 외부에 적용
            child: _isGridView
                ? GridView.builder(
                    shrinkWrap: true, // GridView 크기 자동 조정
                    physics:
                        const NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
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
                      final isFile = photo.isFile;

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                photoFile,
                                fit: BoxFit.cover, // 이미지를 뷰에 맞게 잘라서 채우기
                                width: double.maxFinite, // 가로는 부모 크기에 맞추기
                                height: 130, // 이미지 세로 크기 고정
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              photoName,
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              '${photoDate.year}-${photoDate.month}-${photoDate.day}', // 날짜 표시
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true, // ListView 크기 자동 조정
                    physics:
                        const NeverScrollableScrollPhysics(), // 내부 스크롤 비활성화
                    itemCount: photoList.length,
                    itemBuilder: (context, index) {
                      final photo = photoList[index];
                      final photoName = photo.fileName;
                      final photoDate = photo.date;
                      final isFile = photo.isFile;

                      return Row(
                        children: [
                          isFile
                              ? const Icon(Icons.image)
                              : const Icon(Icons.file_copy),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  photoName,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${photoDate.year}-${photoDate.month}-${photoDate.day}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.more_horiz),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget sortBox(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            print("button view_list");
          },
          icon: const Icon(Icons.file_upload_sharp),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {
            setState(() {
              _isGridView = false; // 리스트 뷰로 변경
            });
            print("Switched to ListView");
          },
          icon: const Icon(Icons.view_list),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isGridView = true; // 그리드 뷰로 변경
            });
            print("Switched to GridView");
          },
          icon: const Icon(Icons.grid_view),
        ),
      ],
    );
  }
}
