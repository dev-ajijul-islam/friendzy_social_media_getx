import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/comment_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class CreateCommentController extends GetxController {
  final TextEditingController commentTEController = .new();
  final GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

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
