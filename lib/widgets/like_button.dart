import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/controllers/like_post_controller.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class LikeButton extends StatelessWidget {
  LikeButton({super.key, required this.post});
  final LikePostController likePostController = Get.find<LikePostController>();

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final isMe = post.likerIds?.contains(
      FirebaseServices.auth.currentUser!.uid,
    );
    return IconButton(
      onPressed: () {
        likePostController.toggleLike(post: post, isMe: isMe);
      },
      icon: Icon(
        isMe! ? Icons.favorite : Icons.favorite_outline,
        color: Colors.red,
      ),
    );
  }
}
