import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  final forgotEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final lastPasswordController = TextEditingController();


  var isPasswordVisible = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final forgotFormKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    if (loginFormKey.currentState!.validate()) {
      debugPrint("Logging in with: ${emailController.text}");
    }
  }

  void resetPassword() {
    if (forgotFormKey.currentState!.validate()) {
      debugPrint("Resetting password for: ${forgotEmailController.text}");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    forgotEmailController.dispose();
    phoneController.dispose();
    lastPasswordController.dispose();
    super.onClose();
  }
}
