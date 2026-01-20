import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  RxBool inProcess = false.obs;

  Future<void> signIn() async {
    inProcess.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Google ID Token is null");
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);

      final userCredential = await FirebaseServices.auth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) return;

      //final user = FirebaseServices.auth.currentUser!;

      // final UserModel userModel = UserModel(
      //   uid: user.uid,
      //   displayName: user.displayName ?? "",
      //   email: user.email ?? "",
      //   photoURL: user.photoURL ?? "",
      // );
      //
      // await saveUserIfNotExists(userModel);

      Get.snackbar(
        "Success",
        "Sign in success",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
      // Get.offNamedUntil(AppRoutes.mainLayout, (route) => false);
    } on FirebaseException catch (e) {
      debugPrint(e.message.toString());
      Get.snackbar("Failed", e.message.toString());
    } finally {
      inProcess.value = false;
    }
  }
}
