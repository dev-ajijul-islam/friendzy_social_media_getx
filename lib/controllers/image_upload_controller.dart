import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:friendzy_social_media_getx/modules/upload_post/controllers/create_or_update_post_controller.dart';
import 'package:friendzy_social_media_getx/widgets/button_loading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

enum Reason { post, story, profile, message }

class ImageUploadController extends GetxController {
  final CreateOrUpdatePostController postUploadController =
      Get.find<CreateOrUpdatePostController>();
  RxBool isUploading = false.obs;

  final StoryController storyController = Get.find<StoryController>();

  final MyProfileController myProfileController =
      Get.find<MyProfileController>();

  Future<void> uploadImage({required Reason reason}) async {
    ImagePicker imagePicker = .new();

    void handleUpload(ImageSource source) async {
      try {
        final uploadUrl = Uri.parse(
          "https://api.imgbb.com/1/upload?key=5350a71f27b5f7f75e8d222f343c8cd4",
        );

        isUploading.value = true;
        final pickedImage = await imagePicker.pickImage(source: source);
        final imageBytes = File(pickedImage!.path).readAsBytes();
        final response = await http.post(
          uploadUrl,
          body: {"image": base64Encode(await imageBytes)},
        );

        final decoded = jsonDecode(response.body);
        if (reason == Reason.post) {
          postUploadController.images.add(decoded["data"]["url"]);
        }

        if (reason == Reason.story) {
          storyController.selectedImages.add(decoded["data"]["url"]);
        }
        if (reason == Reason.profile) {
          final bool isSuccess = await myProfileController.updateProfilePicture(
            decoded["data"]["url"],
          );

          if (isSuccess) {
            Get.back();
            Get.snackbar(
              'Success',
              'Profile picture updated',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
        }
        Get.back();
        Get.snackbar(
          "Success",
          "Image uploaded",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        isUploading.value = false;
      }
    }

    Get.bottomSheet(
      enableDrag: isUploading.value ? false : true,
      isDismissible: isUploading.value ? false : true,
      Container(
        padding: .all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .only(topLeft: .circular(20), topRight: .circular(20)),
        ),

        width: .infinity,
        child: Obx(
          () => Column(
            mainAxisSize: .min,
            spacing: 10,
            crossAxisAlignment: .start,
            children: [
              Text("Upload Image", style: Get.textTheme.titleLarge),
              SizedBox(height: 10),
              Material(
                child: InkWell(
                  onTap: () {
                    isUploading.value ? null : handleUpload(.gallery);
                  },
                  child: ListTile(
                    textColor: Get.theme.colorScheme.primary,
                    trailing: isUploading.value
                        ? ButtonLoading()
                        : Icon(Icons.photo_outlined),
                    shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                    tileColor: Get.theme.colorScheme.secondary.withAlpha(50),
                    title: Text("Choose from Gallery"),
                  ),
                ),
              ),
              Material(
                child: InkWell(
                  onTap: () {
                    isUploading.value ? null : handleUpload(.camera);
                  },
                  child: ListTile(
                    textColor: Get.theme.colorScheme.primary,
                    trailing: isUploading.value
                        ? ButtonLoading()
                        : Icon(Icons.photo_camera_outlined),
                    shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                    tileColor: Get.theme.colorScheme.secondary.withAlpha(50),
                    title: Text("Take a picture"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
