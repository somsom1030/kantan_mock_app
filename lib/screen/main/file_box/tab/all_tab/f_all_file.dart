import 'package:flutter/material.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/all_file_dummy.dart';
import 'package:kantan_mock_app/screen/main/file_box/tab/all_tab/photo_provider.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class AllFragment extends StatelessWidget {
  const AllFragment({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = Provider.of<PhotoProvider>(context).photos;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: 'ファイルBOX'.text.size(18).bold.make(),
        ),
        sortBox(context),
        Expanded(
          child: ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context, index) {
              final photo = photos[index];
              final photoFile = photo['file'];
              final photoName = photo['name'];

              return Row(
                children: [
                  const Icon(Icons.image),
                  const SizedBox(width: 10),
                  Text(photoName),
                  const Spacer(),
                  Image.file(
                    photoFile,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const Icon(Icons.more_horiz),
                ],
              );
            },
          ),
        ),
      ],
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
            print("button view_list");
          },
          icon: const Icon(Icons.view_list),
        ),
        IconButton(
          onPressed: () {
            print("button grid_view");
          },
          icon: const Icon(Icons.grid_view),
        ),
      ],
    );
  }
}
