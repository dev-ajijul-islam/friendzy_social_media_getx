import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class MyProfileController extends GetxController {
   Rx<UserModel> userInfo = UserModel(fullName: '--', email: '--').obs;
  RxBool isProfileInfoLoading = true.obs;

  final user = FirebaseServices.auth.currentUser;

  Future<void> getProfileInfo() async {
    FirebaseServices.firestore
        .collection("users")
        .doc(user?.uid)
        .snapshots()
        .listen((snapshot) {
          userInfo.value = UserModel.fromJson(snapshot.data()!);
          print(userInfo.value.bio.runtimeType);
          isProfileInfoLoading.value = false;
        }, onError: (e) {
          isProfileInfoLoading.value = false;
    });
  }
  @override
  void onInit() {
    getProfileInfo();
    super.onInit();
  }
}
