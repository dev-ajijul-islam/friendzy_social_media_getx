import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class FriendsControllers extends GetxController {
  RxBool isLoading = true.obs;
  RxList<UserModel> allUsers = <UserModel>[].obs;


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
}
