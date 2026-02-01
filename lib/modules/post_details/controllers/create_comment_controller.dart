import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/comment_model.dart';
import 'package:friendzy_social_media_getx/data/models/notification_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/notifications/controllers/notification_controller.dart';
import 'package:get/get.dart';

class CreateCommentController extends GetxController {
  final TextEditingController commentTEController = .new();
  final GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  final NotificationController notificationController = Get.put(
    NotificationController(),
  );

  Future<void> createComment({required CommentModel comment}) async {
    isLoading.value = true;
    try {
      await FirebaseServices.firestore
          .collection("users")
          .doc(comment.postAuthor.uid)
          .collection("posts")
          .doc(comment.postId)
          .collection("comments")
          .add(comment.toJson());

      await FirebaseServices.firestore
          .collection("users")
          .doc(comment.postAuthor.uid)
          .collection("posts")
          .doc(comment.postId)
          .update({"commentsCount": FieldValue.increment(1)});

      notificationController.createNotification(
        notification: NotificationModel(
          image: FirebaseServices.auth.currentUser!.photoURL ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
          message:
              "${FirebaseServices.auth.currentUser!.displayName} is commented on your post",
          createdAt: DateTime.now(),
        ),
        targetUserId: comment.postAuthor.uid!,
      );

      Get.snackbar(
        "Success",
        "Comment uploaded",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
      commentTEController.clear();
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Failed",
        e.message.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
