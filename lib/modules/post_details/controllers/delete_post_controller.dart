import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class DeletePostController extends GetxController {
  RxBool isDeleting = false.obs;

  Future<void> deletePost({required PostModel post}) async {
    isDeleting.value = true;
    try {
      await FirebaseServices.firestore
          .collection("users")
          .doc(post.author.uid)
          .collection("posts")
          .doc(post.postId)
          .delete();
      Get.back();
      Get.snackbar(
        "Success",
        "Post has been deleted",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Failed",
        e.message.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isDeleting.value = false;
    }
  }
}
