import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:get/get.dart';

class PostUploadController extends GetxController {
  RxBool inProcess = false.obs;
  RxList<String> hashtags = <String>[].obs;
  RxList<String> images = <String>[].obs;

  final GlobalKey<FormState> postFormKey = GlobalKey<FormState>();
  final TextEditingController captionController = .new();
  final TextEditingController hashTagController = .new();

  final MainLayoutController mainLayoutController =
      Get.find<MainLayoutController>();

  Future<void> createPost() async {
    if (postFormKey.currentState!.validate()) {
      inProcess.value = true;
      try {
        final currentUser = FirebaseServices.auth.currentUser;

        final author = UserModel(
          uid: currentUser?.uid,
          fullName: currentUser!.displayName.toString(),
          email: currentUser.email.toString(),
          profilePic: currentUser.photoURL,
        );

        final PostModel postModel = PostModel(
          author: author,
          caption: captionController.text.trim(),
          images: images,
          createdAt: DateTime.now(),
        );

        await FirebaseServices.firestore
            .collection("users")
            .doc(FirebaseServices.auth.currentUser?.uid)
            .collection("posts")
            .add(postModel.toJson());

        await FirebaseServices.firestore
            .collection("users")
            .doc(FirebaseServices.auth.currentUser?.uid)
            .update({"postsCount": FieldValue.increment(1)});

        images.close();
        captionController.clear();
        hashTagController.clear();
        hashtags.clear();
        mainLayoutController.selectedIndex.value = 0;

        Get.snackbar(
          "Success",
          "Your post has been uploaded",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } on FirebaseException catch (e) {
        debugPrint(e.message.toString());
        Get.snackbar("Failed", e.message.toString());
      } finally {
        inProcess.value = false;
      }
    }
  }

  void addTag() {
    hashtags.add(hashTagController.text.trim());
    hashTagController.clear();
  }

  void removeTag(int index) {
    hashtags.removeAt(index);
  }
}
