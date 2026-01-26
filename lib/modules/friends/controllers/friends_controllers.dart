import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class FriendsControllers extends GetxController {
  RxBool isLoading = true.obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;

  final auth = FirebaseServices.auth;

  @override
  void onInit() {
    getAllUsers();
    super.onInit();
  }

  void getAllUsers() async {
    FirebaseServices.firestore.collection("users").snapshots().listen((
      snapshot,
    ) {
      allUsers.value = snapshot.docs
          .map((u) => UserModel.fromJson(u.data()))
          .toList();
      isLoading.value = false;
    });
  }

  Future<void> toggleFollow({required UserModel targetUser}) async {
    isLoading.value = true;

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

        Get.snackbar("Success", "Unfollowed ${targetUser.fullName}");
      } else {
        batch.set(
          FirebaseServices.firestore
              .collection("users")
              .doc(currentUser.uid)
              .collection("following")
              .doc(targetUser.uid),
          {...targetUser.toJson(), 'followedAt': FieldValue.serverTimestamp()},
        );

        batch.set(
          FirebaseServices.firestore
              .collection("users")
              .doc(targetUser.uid)
              .collection("followers")
              .doc(currentUser.uid),
          {...currentUser.toJson(), 'followedAt': FieldValue.serverTimestamp()},
        );

        batch.update(
          FirebaseServices.firestore.collection("users").doc(currentUser.uid),
          {'followingCount': FieldValue.increment(1)},
        );

        batch.update(
          FirebaseServices.firestore.collection("users").doc(targetUser.uid),
          {'followersCount': FieldValue.increment(1)},
        );

        Get.snackbar("Success", "Following ${targetUser.fullName}");
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      Get.snackbar("Failed", e.message.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
