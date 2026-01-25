import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  final TextEditingController captionController = TextEditingController();
  final storiesByUser = <StoryModel>[].obs;

  RxBool isLoading = false.obs;

  final RxInt currentUserIndex = 0.obs;
  final RxDouble progress = 0.0.obs;
  final RxList<String> selectedImages = <String>[].obs;

  Timer? _timer;
  final storyDuration = const Duration(seconds: 10);

  @override
  void onInit() {
    super.onInit();
    getAllStories();
  }

  //-----------------GET ALL STORIES------------------
  void getAllStories() {
    FirebaseServices.firestore.collectionGroup("stories").snapshots().listen(
          (snapshot) {
        storiesByUser.value = snapshot.docs
            .map((doc) => StoryModel.fromJson(doc.data()))
            .toList();

        // Reset index if necessary
        if (storiesByUser.isEmpty) {
          currentUserIndex.value = 0;
          _timer?.cancel();
        } else {
          startProgress();
        }
      },
    );
  }

  //------------------ CREATE STORY ------------------
  Future<void> createStory() async {
    if (selectedImages.isEmpty) {
      Get.snackbar("No Images", "Please select at least one image for your story",
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    final User user = FirebaseServices.auth.currentUser!;
    final StoryModel storyData = StoryModel(
      story: StoryItem(
        images: selectedImages,
        captions: captionController.text.trim(),
        viewers: [],
        reactors: [],
      ),
      author: UserModel(
        fullName: user.displayName ?? "",
        email: user.email ?? "",
        profilePic: user.photoURL ?? "",
        uid: user.uid,
      ),
    );

    try {
      await FirebaseServices.firestore
          .collection("users")
          .doc(user.uid)
          .collection("stories")
          .add(storyData.toJson());

      Get.snackbar("Success", "Story posted successfully",
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.green);

      selectedImages.clear();
      captionController.clear();
    } on FirebaseException catch (e) {
      Get.snackbar("Failed", e.message.toString(), snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false;
    }
  }

  //------------------ HELPERS ------------------
  StoryModel? get currentUser =>
      storiesByUser.isNotEmpty ? storiesByUser[currentUserIndex.value] : null;

  StoryItem? get currentStory => currentUser?.story;

  //------------------ PROGRESS HANDLER ------------------
  void startProgress() {
    _timer?.cancel();
    progress.value = 0;

    // Only start progress if there is a current story
    if (currentStory == null) return;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      progress.value += 0.01;

      if (progress.value >= 1) {
        nextUser();
      }
    });
  }

  //------------------ USER NAVIGATION ------------------
  void nextUser() {
    _timer?.cancel();

    _addViewer();

    if (storiesByUser.isEmpty) return;

    if (currentUserIndex.value < storiesByUser.length - 1) {
      currentUserIndex.value++;
      startProgress();
    } else {
      Get.back();
    }
  }

  void previousUser() {
    _timer?.cancel();

    if (storiesByUser.isEmpty) return;

    if (currentUserIndex.value > 0) {
      currentUserIndex.value--;
      startProgress();
    }
  }

  //------------------ VIEW + REACT ------------------
  void _addViewer() {
    if (currentStory == null) return;

    final me = UserModel(email: "ajijul@gmail.com", fullName: "Ajijul Islam");
    final viewers = currentStory!.viewers;

    if (!viewers.any((u) => u.email == me.email)) {
      viewers.add(me);
    }
  }

  void react() {
    if (currentStory == null) return;

    final me = UserModel(email: "x@gmail.com", fullName: 'My Account', profilePic: '');
    final reactors = currentStory!.reactors;

    if (!reactors.any((u) => u.email == me.email)) {
      reactors.add(me);
      Get.snackbar('Reaction', 'You reacted to this story ❤️', snackPosition: SnackPosition.TOP);
    } else {
      Get.snackbar('Reaction', 'You already reacted to this story', snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
