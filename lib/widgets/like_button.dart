import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/controllers/like_post_controller.dart';
import 'package:friendzy_social_media_getx/data/models/notification_model.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/notifications/controllers/notification_controller.dart';
import 'package:get/get.dart';

class LikeButton extends StatelessWidget {
  LikeButton({super.key, required this.post});
  final LikePostController likePostController = Get.find<LikePostController>();
  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final isMe = post.likerIds?.contains(
      FirebaseServices.auth.currentUser!.uid,
    );
    return IconButton(
      onPressed: () {
        likePostController.toggleLike(post: post, isMe: isMe);
        if (!isMe) {
          notificationController.createNotification(
            notification: NotificationModel(
              image: FirebaseServices.auth.currentUser!.photoURL.toString(),
              message:
                  "${FirebaseServices.auth.currentUser!.displayName} reacted to your post",
              createdAt: DateTime.now(),
            ),
            targetUserId: post.author.uid!,
          );
        }else{
          notificationController.createNotification(
            notification: NotificationModel(
              image: FirebaseServices.auth.currentUser!.photoURL.toString(),
              message:
              "${FirebaseServices.auth.currentUser!.displayName} reacted to your post",
              createdAt: DateTime.now(),
            ),
            targetUserId: post.author.uid!,
          );
        }
      },
      icon: Icon(
        isMe! ? Icons.favorite : Icons.favorite_outline,
        color: Colors.red,
      ),
    );
  }
}
