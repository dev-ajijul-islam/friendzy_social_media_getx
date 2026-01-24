import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({super.key, required this.postModel});
  final PostModel postModel;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.toNamed(AppRoutes.postDetailsScreen, arguments: postModel);
      },
      icon: Icon(Icons.chat_bubble_outline, color: Colors.black),
    );
  }
}
