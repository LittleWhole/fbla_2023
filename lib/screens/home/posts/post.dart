import 'dart:io';
import 'dart:math';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_image_gallery/swipe_image_gallery.dart';

import '../../../services/auth.dart';
import '../../../services/database.dart';
import '../../../services/storage.dart';
import '../../../shared/constants.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final AuthService _auth = AuthService();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images;
  String caption = '';

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
                    const Text('New Post', style: titleStyle),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: OutlinedButton(
                      child: Row(
                        children: [
                          const Icon(Icons.send),
                          const Padding(padding: const EdgeInsets.all(2)),
                          const Text('Post')
                        ],
                      ),
                      onPressed: () async {
                        String uid = _auth.currentUser().uid;
                        DateTime now = DateTime.now();
                        String id = await DatabaseService(uid: uid)
                            .newPost(uid, caption, [''], now)
                            .then((value) => value.id);
                        await StorageService()
                            .uploadImages(
                                filePath: id,
                                imageFiles:
                                    images!.map((e) => File(e.path)).toList())
                            .then((value) async {
                          await DatabaseService(uid: uid)
                              .updatePost(id, uid, caption, value, now)
                              .then((value) => Navigator.pop(context));
                        });
                      }),
                ),
              ],
            ),
            //const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) => {
                        setState(() {
                          caption = value;
                        })
                      },
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter a caption...'),
                    ),
                    Card(
                      color: Colors.blue,
                      child: ListTile(
                        textColor: Colors.white,
                        title: const Text('Pick images'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () async {
                          images = await _picker.pickMultiImage();
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: images?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(
                              children: [
                                Image(
                                  image: XFileImage(images![index]),
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Image ${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        },
                      ),
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
