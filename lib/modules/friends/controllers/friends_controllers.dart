import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class FriendsControllers extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFollowingLoading = false.obs;
  RxString loadingUserId = ''.obs;

  RxList<UserModel> allUsers = <UserModel>[].obs;
  final TextEditingController searchController = TextEditingController();
  RxList<UserModel> filteredUsers = <UserModel>[].obs;

  final auth = FirebaseServices.auth;

  @override
  void onInit() {
    getAllUsers();
    searchController.addListener(_filterUsers);
    super.onInit();
  }


  void getAllUsers() async {
    isLoading.value = true;
    FirebaseServices.firestore
        .collection("users")
        .where('uid', isNotEqualTo: auth.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      allUsers.value =
          snapshot.docs.map((u) => UserModel.fromJson(u.data())).toList();
      filteredUsers.value = allUsers;
      isLoading.value = false;
    });
  }

  void _filterUsers() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredUsers.value = allUsers;
    } else {
      filteredUsers.value = allUsers
          .where((user) =>
      user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query))
          .toList();
    }
  }

  Stream<bool> isFollowingStream(String targetUserId) {
    return FirebaseServices.firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .doc(targetUserId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> toggleFollow({required UserModel targetUser}) async {
    final currentUser = UserModel(
      fullName: auth.currentUser!.displayName.toString(),
      email: auth.currentUser!.email.toString(),
      uid: auth.currentUser!.uid,
      profilePic: auth.currentUser!.photoURL.toString(),
    );

    try {
      final followingDoc = await FirebaseServices.firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("following")
          .doc(targetUser.uid)
          .get();

      final batch = FirebaseServices.firestore.batch();

      if (followingDoc.exists) {
        // Unfollow
        batch.delete(
          FirebaseServices.firestore
              .collection("users")
              .doc(currentUser.uid)
              .collection("following")
              .doc(targetUser.uid),
        );

        batch.delete(
          FirebaseServices.firestore
              .collection("users")
              .doc(targetUser.uid)
              .collection("followers")
              .doc(currentUser.uid),
        );

        batch.update(
          FirebaseServices.firestore.collection("users").doc(currentUser.uid),
          {'followingCount': FieldValue.increment(-1)},
        );

        batch.update(
          FirebaseServices.firestore.collection("users").doc(targetUser.uid),
          {'followersCount': FieldValue.increment(-1)},
        );

        await batch.commit();
        Get.snackbar("Success", "Unfollowed ${targetUser.fullName}");
      } else {
        // Follow
        batch.set(
          FirebaseServices.firestore
              .collection("users")
              .doc(currentUser.uid)
              .collection("following")
              .doc(targetUser.uid),
          {
            ...targetUser.toJson(),
            'followedAt': FieldValue.serverTimestamp()
          },
        );

        batch.set(
          FirebaseServices.firestore
              .collection("users")
              .doc(targetUser.uid)
              .collection("followers")
              .doc(currentUser.uid),
          {
            ...currentUser.toJson(),
            'followedAt': FieldValue.serverTimestamp()
          },
        );

        batch.update(
          FirebaseServices.firestore.collection("users").doc(currentUser.uid),
          {'followingCount': FieldValue.increment(1)},
        );

        batch.update(
          FirebaseServices.firestore.collection("users").doc(targetUser.uid),
          {'followersCount': FieldValue.increment(1)},
        );

        await batch.commit();
        Get.snackbar("Success", "Following ${targetUser.fullName}");
      }
    } on FirebaseException catch (e) {
      Get.snackbar("Failed", e.message.toString());
    }
  }
}