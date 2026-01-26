import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class FollowersControllers extends GetxController {
  RxBool isLoading = true.obs;
  RxList<UserModel> followers = <UserModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  RxList<UserModel> filteredFollowers = <UserModel>[].obs;

  final auth = FirebaseServices.auth;

  @override
  void onInit() {
    getFollowers();
    searchController.addListener(_filterFollowers);
    super.onInit();
  }

  void getFollowers() {
    FirebaseServices.firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("followers")
        .snapshots()
        .listen((snapshot) {
          followers.value = snapshot.docs
              .map((u) => UserModel.fromJson(u.data()))
              .toList();
          filteredFollowers.value = followers;
          isLoading.value = false;
        });
  }

  void _filterFollowers() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredFollowers.value = followers;
    } else {
      filteredFollowers.value = followers
          .where(
            (user) =>
                user.fullName.toLowerCase().contains(query) ||
                user.email.toLowerCase().contains(query),
          )
          .toList();
    }
  }
}
