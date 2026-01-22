import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class GetAllPostController extends GetxController {
  @override
  void onInit() {
    getAllPost();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  RxList<PostModel> posts = <PostModel>[].obs;

  void getAllPost() async {
    FirebaseServices.firestore.collectionGroup("posts").snapshots().listen((
      snapshot,
    ) {
      posts.value = snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data()))
          .toList();
      isLoading.value = false;
    },onError: (e){
      isLoading.value = false;
      Get.snackbar("Failed", e.toString(),colorText: Colors.white,backgroundColor: Colors.green);
    });
  }
}
