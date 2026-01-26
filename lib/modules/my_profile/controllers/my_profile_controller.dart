import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class MyProfileController extends GetxController {
  // Existing code - don't change
  Rx<UserModel> userInfo = UserModel(fullName: '--', email: '--').obs;
  RxBool isProfileInfoLoading = true.obs;
  final user = FirebaseServices.auth.currentUser;

  // New code for Edit Profile
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController =
      TextEditingController(); // Added
  final TextEditingController regionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  RxBool isUpdating = false.obs;
  RxMap<String, dynamic> updatedFields = <String, dynamic>{}.obs;

  @override
  void onInit() {
    getProfileInfo();
    super.onInit();
  }

  Future<void> getProfileInfo() async {
    FirebaseServices.firestore
        .collection("users")
        .doc(user?.uid)
        .snapshots()
        .listen(
          (snapshot) {
            userInfo.value = UserModel.fromJson(snapshot.data()!);
            isProfileInfoLoading.value = false;
            _populateFormFields();
          },
          onError: (e) {
            isProfileInfoLoading.value = false;
          },
        );
  }

  // New method: Populate form fields with current user data
  void _populateFormFields() {
    final user = userInfo.value;

    usernameController.text = user.username ?? '';
    fullNameController.text = user.fullName; // Added
    regionController.text = user.region ?? '';
    phoneNumberController.text =
        user.phoneNumber ?? ''; // Assuming phoneNumber exists in model
    genderController.text = user.gender ?? '';
    bioController.text = user.bio ?? '';
  }

  // New method: Update a specific field
  void updateField(String fieldName, dynamic value) {
    updatedFields[fieldName] = value;
  }

  // New method: Save profile to both Firebase Auth and Firestore
  Future<bool> saveProfile() async {
    isUpdating.value = true;

    try {
      final currentAuthUser = FirebaseServices.auth.currentUser;
      if (currentAuthUser == null) {
        Get.snackbar('Error', 'User not authenticated');
        return false;
      }

      // Prepare updated data - now includes fullName
      final updatedData = <String, dynamic>{
        'username': usernameController.text.trim().isEmpty
            ? null
            : usernameController.text.trim(),
        'fullName': fullNameController.text.trim(), // Added
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

      // Remove null values except fullName (which is required)
      updatedData.removeWhere(
        (key, value) => value == null && key != 'fullName',
      );

      // Update Firebase Auth display name
      if (updatedData['username'] != null &&
          updatedData['username'].toString().isNotEmpty) {
        await currentAuthUser.updateDisplayName(updatedData['username']);
      }

      // Also update Firebase Auth for display name if fullName changed
      if (updatedData['fullName'] != null &&
          updatedData['fullName'].toString().isNotEmpty) {
        // Update Firebase Auth profile
        await currentAuthUser.updateProfile(
          displayName: updatedData['fullName'],
        );
      }

      // Update Firestore user document
      await FirebaseServices.firestore
          .collection('users')
          .doc(currentAuthUser.uid)
          .update(updatedData);

      // Update local user model
      _updateLocalUser(updatedData);

      // Clear updated fields
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

      // Update Firebase Auth photoURL
      if (imageUrl != null) {
        await currentAuthUser.updatePhotoURL(imageUrl);
      }

      // Update Firestore user document
      await FirebaseServices.firestore
          .collection('users')
          .doc(currentAuthUser.uid)
          .update({
            'profilePic': imageUrl,
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Update local user model
      userInfo.value = userInfo.value.copyWith(profilePic: imageUrl);

      Get.snackbar('Success', 'Profile picture updated');
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile picture');
      return false;
    } finally {
      isUpdating.value = false;
    }
  }

  // Helper method: Update local user model
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

  // New method: Validate form
  bool validateForm() {
    if (usernameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Username is required');
      return false;
    }

    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Validation Error', 'Full name is required');
      return false;
    }

    // Validate phone number format
    final phone = phoneNumberController.text.trim();
    if (phone.isNotEmpty && !RegExp(r'^[0-9]{10,11}$').hasMatch(phone)) {
      Get.snackbar('Validation Error', 'Please enter a valid phone number');
      return false;
    }

    return true;
  }

  // New method: Reset form to original values
  void resetForm() {
    _populateFormFields();
    updatedFields.clear();
  }

  // New method: Check if form has changes
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
