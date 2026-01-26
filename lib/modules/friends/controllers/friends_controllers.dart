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

  Future<void> followUser({required UserModel toFollow}) async {
    isLoading.value = true;
    final UserModel currentUser = UserModel(
      fullName: auth.currentUser!.displayName.toString(),
      email: auth.currentUser!.email.toString(),
      uid: auth.currentUser!.uid,
      profilePic: auth.currentUser!.photoURL.toString(),
    );
    try {
      await FirebaseServices.firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("following")
          .add(toFollow.toJson());

      await FirebaseServices.firestore
          .collection("users")
          .doc(toFollow.uid)
          .collection("followers")
          .add(currentUser.toJson());
    } on FirebaseException catch (e) {
      Get.snackbar("Failed", e.message.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
