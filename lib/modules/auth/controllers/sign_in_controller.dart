import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/auth/utils/save_user.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  RxBool isEmailSignInProgress = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final forgotEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final lastPasswordController = TextEditingController();

  var isPasswordVisible = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isEmailSignInProgress.value = true;
      try {
        await FirebaseServices.auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        final user = FirebaseServices.auth.currentUser!;

        final UserModel userModel = UserModel(
          uid: user.uid,
          fullName: user.displayName ?? "",
          email: user.email ?? "",
          profilePic: user.photoURL ?? "",
        );

        await saveUserIfNotExists(userModel);
        _clearForm();
        Get.offAndToNamed(AppRoutes.mainLayout);
        Get.snackbar(
          "Success",
          "Sign in success",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } on FirebaseException catch (e) {
        debugPrint(e.message.toString());
        Get.snackbar(
          "Failed",
          e.message.toString(),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      } finally {
        isEmailSignInProgress.value = false;
      }
    }
  }

  void resetPassword() {
    // if (forgotFormKey.currentState!.validate()) {
    //   debugPrint("Resetting password for: ${forgotEmailController.text}");
    // }
  }

  // @override
  // void onClose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   forgotEmailController.dispose();
  //   phoneController.dispose();
  //   lastPasswordController.dispose();
  //   super.onClose();
  //}

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
  }
}
