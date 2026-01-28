import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class SearchPostController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  RxBool isSearching = false.obs;
  RxList<PostModel> allPosts = <PostModel>[].obs;
  RxList<PostModel> posts = <PostModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
  }

  Future<void> fetchAllPosts() async {
    try {
      final querySnapshot = await FirebaseServices.firestore
          .collectionGroup("posts")
          .get();

      final result = querySnapshot.docs
          .map((doc) => PostModel.fromJson({...doc.data(), "postId": doc.id}))
          .toList();

      allPosts.assignAll(result);
      posts.assignAll(result);
    } on FirebaseException catch (e) {
      debugPrint(e.message.toString());
    }
  }

  void localSearch() {
    final searchText = searchController.text.trim().toLowerCase();

    if (searchText.isEmpty) {
      posts.assignAll(allPosts);
      return;
    }

    isSearching.value = true;

    final filtered = allPosts.where((post) {
      final caption = post.caption.toLowerCase();
      final fullName = post.author.fullName.toLowerCase();
      final email = post.author.email.toLowerCase();
      final username = post.author.username?.toLowerCase() ?? '';

      return caption.contains(searchText) ||
          fullName.contains(searchText) ||
          email.contains(searchText) ||
          username.contains(searchText);
    }).toList();

    posts.assignAll(filtered);
    isSearching.value = false;
  }
}
