import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:get/get.dart';

class CreateOrUpdatePostController extends GetxController {
  RxBool inProcess = false.obs;
  RxList<String> hashTags = <String>[].obs;
  RxList<String> images = <String>[].obs;

  final GlobalKey<FormState> postFormKey = GlobalKey<FormState>();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController hashTagController = TextEditingController();

  final MainLayoutController mainLayoutController = Get.put(
    MainLayoutController(),
  );

  Future<void> createOrUpdatePost({
    PostModel? existingPost,
    bool isUpdate = false,
  }) async {
    if (!postFormKey.currentState!.validate()) return;

    inProcess.value = true;

    try {
      final currentUser = FirebaseServices.auth.currentUser;

      if (currentUser == null) {
        throw Exception("User not logged in");
      }

      final author = UserModel(
        uid: currentUser.uid,
        fullName: currentUser.displayName ?? "",
        email: currentUser.email ?? "",
        profilePic: currentUser.photoURL,
      );

      final PostModel postModel = PostModel(
        postId: existingPost?.postId,
        author: author,
        caption: captionController.text.trim(),
        images: images.toList(),
        hashTags: hashTags.toList(),
        createdAt: isUpdate ? existingPost!.createdAt : DateTime.now(),
      );

      final userPostRef = FirebaseServices.firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("posts");

      if (isUpdate && existingPost != null && existingPost.postId != null) {
        await userPostRef.doc(existingPost.postId).update(postModel.toJson());

        Get.back();
        Get.back();

        Get.snackbar(
          "Updated",
          "Your post has been updated",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } else {
        await userPostRef.add(postModel.toJson());

        await FirebaseServices.firestore
            .collection("users")
            .doc(currentUser.uid)
            .update({"postsCount": FieldValue.increment(1)});

        Get.back();

        Get.snackbar(
          "Success",
          "Your post has been uploaded",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }

      clearForm();
      mainLayoutController.selectedIndex.value = 0;
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      Get.snackbar(
        "Failed",
        e.message ?? "Something went wrong",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        "Error",
        e.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      inProcess.value = false;
    }
  }

  void addTag() {
    final tag = hashTagController.text.trim();
    if (tag.isEmpty) return;
    hashTags.add(tag);
    hashTagController.clear();
  }

  void removeTag(int index) {
    if (index < hashTags.length) {
      hashTags.removeAt(index);
    }
  }

  void clearForm() {
    captionController.clear();
    hashTagController.clear();
    hashTags.clear();
    images.clear();
  }
}
