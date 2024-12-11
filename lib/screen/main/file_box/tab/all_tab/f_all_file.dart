import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kantan_mock_app/common/utility/upload_file_check.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/f_preview_screen.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/photo_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class AllFragment extends StatefulWidget {
  const AllFragment({super.key});

  @override
  State<AllFragment> createState() => _AllFragmentState();
}

class _AllFragmentState extends State<AllFragment> {
  bool _isGridView = false; // 현재 뷰 상태를 저장 (리스트 뷰 또는 그리드 뷰)

  @override
  Widget build(BuildContext context) {
    final fileList = Provider.of<PhotoProvider>(context).fileList;

    return SingleChildScrollView(
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
            padding: const EdgeInsets.all(16.0),
            child: _isGridView
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: fileList.length,
                    itemBuilder: (context, index) {
                      final file = fileList[index];
                      final filePath = file.filePath;
                      final fileName = file.fileName;
                      final fileDate = file.date;
                      final isFile = file.isFile;
                      print("filePath  : $filePath");

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewScreen(
                                filePath: filePath,
                                fileName: fileName,
                                fileDate: fileDate,
                                fileType: isFile,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child:
                                      buildFileWidget(isFile, file: filePath),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fileName,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                '${fileDate.year}-${fileDate.month}-${fileDate.day}',
                                style: const TextStyle(
                                    fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: fileList.length,
                    itemBuilder: (context, index) {
                      final file = fileList[index];
                      final filePath = file.filePath;
                      final fileName = file.fileName;
                      final fileDate = file.date;
                      final isFile = file.isFile;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewScreen(
                                filePath: filePath,
                                fileName: fileName,
                                fileDate: fileDate,
                                fileType: isFile,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            _getFileIcon(isFile),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fileName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${fileDate.year}-${fileDate.month}-${fileDate.day}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.more_horiz),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _getFileIcon(String fileType) {
    switch (fileType) {
      case "jpg":
      case "png":
        return const Icon(Icons.image, color: Colors.blue);
      case "pdf":
        return const Icon(Icons.picture_as_pdf_sharp, color: Colors.red);
      case "xlsx":
        return const Icon(Icons.view_list, color: Colors.green);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
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
              _isGridView = false;
            });
          },
          icon: const Icon(Icons.view_list),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _isGridView = true;
            });
          },
          icon: const Icon(Icons.grid_view),
        ),
      ],
    );
  }
}
