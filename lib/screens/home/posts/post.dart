import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../../../shared/constants.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsetsDirectional.only(top: 40)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    const Text('My Students', style: titleStyle),
                  ],
                ),
              ],
            ),
            //const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Card(
                          color: Colors.blue,
                          child: ListTile(
                            textColor: Colors.white,
                            title: const Text('Pick an image'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () async {
                              final List<XFile>? images =
                                  await _picker.pickMultiImage();
                              SwipeImageGallery(
                                  context: context,
                                  itemBuilder: (context, index) =>
                                      Image(image: XFileImage(images[index])),
                                  itemCount: images!.length);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
