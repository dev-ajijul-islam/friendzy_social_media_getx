import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class FollowingControllers extends GetxController {
  RxBool isLoading = true.obs;
  RxList<UserModel> followingUsers = <UserModel>[].obs;

  final auth = FirebaseServices.auth;

  @override
  void onInit() {
    getFollowingUsers();
    super.onInit();
  }

  void getFollowingUsers() async {
    FirebaseServices.firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection("following")
        .snapshots()
        .listen((snapshot) {
          followingUsers.value = snapshot.docs
              .map((u) => UserModel.fromJson(u.data()))
              .toList();
          isLoading.value = false;
        });
  }
}
