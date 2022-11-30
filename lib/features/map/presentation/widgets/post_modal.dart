import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../core/navigation/app_navigator.dart';
import '../../../../core/widgets/screen.dart';
import '../../../post/domain/entities/post.dart';

class PostModal extends StatelessWidget {
  final AppNavigator appNavigator;
  final Post post;

  const PostModal({
    Key key,
    this.appNavigator,
    this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWidget(
      appBar: AppBar(title: Text(post.category.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: ListBody(
              children: [
                Text(
                  '${post.category.name} - ${post.category.scientificName}',
                ),
                Divider(),
                Text(
                  '${post.location.lat} / ${post.location.lng}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 3),
            ),
            child: Image.file(
              File(post.imageUrl),
            ),
          ),
        ],
      ),
    );
  }
}
