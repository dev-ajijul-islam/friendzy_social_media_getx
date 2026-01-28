import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class MyProfileController extends GetxController {
  Rx<UserModel> userInfo = UserModel(fullName: '--', email: '--').obs;
  RxBool isProfileInfoLoading = true.obs;

  final UserModel user = UserModel(
    fullName: FirebaseServices.auth.currentUser!.displayName.toString(),
    email: FirebaseServices.auth.currentUser!.email.toString(),
    uid: FirebaseServices.auth.currentUser!.uid.toString(),
  );

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  RxBool isUpdating = false.obs;
  RxMap<String, dynamic> updatedFields = <String, dynamic>{}.obs;
  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  @override
  void onInit() {
    getProfileInfo();
    super.onInit();
  }

  void getProfileInfo() async {
    FirebaseServices.firestore
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen(
          (snapshot) async {
            userInfo.value = UserModel.fromJson(snapshot.data()!);
            isProfileInfoLoading.value = false;
            _populateFormFields();
          },
          onError: (e) {
            isProfileInfoLoading.value = false;
          },
        );
  }

  void _populateFormFields() {
    final user = userInfo.value;
    usernameController.text = user.username ?? '';
    fullNameController.text = user.fullName;
    regionController.text = user.region ?? '';
    phoneNumberController.text = user.phoneNumber ?? '';
    genderController.text = user.gender ?? '';
    bioController.text = user.bio ?? '';
  }

  void updateField(String fieldName, dynamic value) {
    updatedFields[fieldName] = value;
  }

  Future<bool> saveProfile() async {
    isUpdating.value = true;

    try {
      final currentAuthUser = FirebaseServices.auth.currentUser;
      if (currentAuthUser == null) {
        Get.snackbar('Error', 'User not authenticated');
        return false;
      }

      final updatedData = <String, dynamic>{
        'username': usernameController.text.trim().isEmpty
            ? null
            : usernameController.text.trim(),
        'fullName': fullNameController.text.trim(),
        'region': regionController.text.trim().isEmpty
            ? null
            : regionController.text.trim(),
        'gender': genderController.text.trim().isEmpty
            ? null
            : genderController.text.trim(),
        'bio': bioController.text.trim().isEmpty
            ? null
            : bioController.text.trim(),
        'phoneNumber': phoneNumberController.text.trim().isEmpty
            ? null
            : phoneNumberController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      updatedData.removeWhere(
        (key, value) => value == null && key != 'fullName',
      );

      if (updatedData['username'] != null &&
          updatedData['username'].toString().isNotEmpty) {
        await currentAuthUser.updateDisplayName(updatedData['username']);
      }

      if (updatedData['fullName'] != null &&
          updatedData['fullName'].toString().isNotEmpty) {
        await currentAuthUser.updateProfile(
          displayName: updatedData['fullName'],
        );
      }

      await FirebaseServices.firestore
          .collection('users')
          .doc(currentAuthUser.uid)
          .update(updatedData);

      _updateLocalUser(updatedData);

      updatedFields.clear();
      Get.back();
      Get.snackbar('Success', 'Profile updated successfully');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  Future<bool> updateProfilePicture(String? imageUrl) async {
    isUpdating.value = true;

    try {
      final currentAuthUser = FirebaseServices.auth.currentUser;
      if (currentAuthUser == null) return false;

      if (imageUrl != null) {
        await currentAuthUser.updatePhotoURL(imageUrl);
      }
      
      await FirebaseServices.auth.currentUser?.updatePhotoURL(imageUrl);

      await FirebaseServices.firestore
          .collection('users')
          .doc(currentAuthUser.uid)
          .update({
            'profilePic': imageUrl,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      userInfo.value = userInfo.value.copyWith(profilePic: imageUrl);



      return true;
    } on FirebaseException catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile picture',
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  void _updateLocalUser(Map<String, dynamic> updatedData) {
    userInfo.value = userInfo.value.copyWith(
      username: updatedData['username'] ?? userInfo.value.username,
      fullName: updatedData['fullName'] ?? userInfo.value.fullName,
      bio: updatedData['bio'] ?? userInfo.value.bio,
      region: updatedData['region'] ?? userInfo.value.region,
      gender: updatedData['gender'] ?? userInfo.value.gender,
      phoneNumber: updatedData['phoneNumber'] ?? userInfo.value.phoneNumber,
    );
  }

  bool validateForm() {
    if (usernameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Username is required');
      return false;
    }

    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Full name is required');
      return false;
    }

    final phone = phoneNumberController.text.trim();
    if (phone.isNotEmpty && !RegExp(r'^[0-9]{10,11}$').hasMatch(phone)) {
      Get.snackbar('Validation Error', 'Please enter a valid phone number');
      return false;
    }

    return true;
  }

  void resetForm() {
    _populateFormFields();
    updatedFields.clear();
  }

  bool get hasChanges {
    final user = userInfo.value;

    return usernameController.text.trim() != (user.username ?? '') ||
        fullNameController.text.trim() != user.fullName ||
        regionController.text.trim() != (user.region ?? '') ||
        genderController.text.trim() != (user.gender ?? '') ||
        phoneNumberController.text.trim() != (user.phoneNumber ?? '') ||
        bioController.text.trim() != (user.bio ?? '');
  }
}
