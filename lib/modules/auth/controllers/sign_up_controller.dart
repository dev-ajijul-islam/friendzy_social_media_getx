import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final forgotEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final lastPasswordController = TextEditingController();

  var isPasswordVisible = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  RxBool isEmailSignInProgress = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signUp() async {
    if (loginFormKey.currentState!.validate()) {
      isEmailSignInProgress.value = true;
      try {
        await FirebaseServices.auth
            .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text,
            )
            .then((credentials) {
              return credentials.user?.updateDisplayName(
                nameController.text.trim(),
              );
            });
        _clearForm();
        await FirebaseServices.auth.signOut();
        Get.back();
        Get.snackbar(
          "Success",
          "Account created successfully",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } on FirebaseException catch (e) {
        debugPrint(e.message);
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
  // }

  void _clearForm() {
    emailController.clear();
    nameController.clear();
    passwordController.clear();
  }
}
