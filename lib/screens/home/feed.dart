import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../services/auth.dart';
import '../../services/database.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  static const TextStyle titleStyle =
      TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
  static const double avatarDiameter = 44;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return //Container(
        //child:
        /*Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'Feed',
            style: titleStyle,
          ),
        ),*/
        _postsListView();
    //);
  }

  Widget _postAuthorRow(Future<String> author) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: avatarDiameter,
            height: avatarDiameter,
            decoration: const BoxDecoration(
              color: const Color(0xFF2B4A9D),
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://www.w3schools.com/howto/img_avatar.png'),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(avatarDiameter / 2),
              child: Image.network(
                'https://www.w3schools.com/howto/img_avatar.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        FutureBuilder(
            future: author,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
              } else {
                return const Text('Loading...');
              }
            }),
      ],
    );
  }

  Widget _postImage(String imageURL) {
    /*return Container(
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: const Color(0xFF2B4A9D),
        shape: BoxShape.rectangle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage('https://www.w3schools.com/howto/img_avatar.png'),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarDiameter / 2),
        child: Image.network(
          'https://www.w3schools.com/howto/img_avatar.png',
          fit: BoxFit.cover,
        ),
      ),
    );*/
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imageURL,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget _postCaption(String caption) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Text(caption));
  }

  Widget _postView(
      Future<String> author, String imageURL, String caption, String id) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _postAuthorRow(author),
            _postImage(imageURL),
            _postCaption(caption),
            _postCommentsButton(id)
          ],
        ),
      ),
    );
  }

  Widget _postCommentsButton(String id) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: GestureDetector(
          onTap: () {
            print("Comments");
          },
          child: Text(
            "View comments",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ));
  }

  Widget _postsListView() {
    DatabaseService db_ = DatabaseService(uid: _auth.currentUser().uid);
    return FutureBuilder(
        future: db_.posts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _postView(
                    db_.fetchUserName(snapshot.data![index]['user']),
                    snapshot.data![index]['images'][0],
                    snapshot.data![index]['caption'],
                    'test');
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
    /*return ListView.builder(
      itemCount: ,
      itemBuilder: (context, index) {
        return _postView();
      },
    );*/
  }
}
