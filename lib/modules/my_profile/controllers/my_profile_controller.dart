import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class MyProfileController extends GetxController {
  late final UserModel userInfo;
  RxBool isProfileInfoLoading = true.obs;

  final user = FirebaseServices.auth.currentUser;

  Future<void> getProfileInfo() async {
    FirebaseServices.firestore
        .collection("users")
        .doc(user?.uid)
        .snapshots()
        .listen(
          (snapshot) {
            userInfo = UserModel.fromJson(snapshot.data()!);
            isProfileInfoLoading.value = false;
          },
          onError: (e) {
            isProfileInfoLoading.value = false;
          },
        );
  }

  @override
  void onInit() {
    getProfileInfo();
    super.onInit();
  }
}
