import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class FollowingControllers extends GetxController {
  RxBool isLoading = true.obs;
  RxList<UserModel> followingUsers = <UserModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  RxList<UserModel> filteredFollowing = <UserModel>[].obs;

  final auth = FirebaseServices.auth;

  @override
  void onInit() {
    getFollowingUsers();
    searchController.addListener(_filterFollowing);
    super.onInit();
  }



  void getFollowingUsers() {
    FirebaseServices.firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .snapshots()
        .listen((snapshot) {
      followingUsers.value =
          snapshot.docs.map((u) => UserModel.fromJson(u.data())).toList();
      filteredFollowing.value = followingUsers;
      isLoading.value = false;
    });
  }

  void _filterFollowing() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredFollowing.value = followingUsers;
    } else {
      filteredFollowing.value = followingUsers
          .where((user) =>
      user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query))
          .toList();
    }
  }
}