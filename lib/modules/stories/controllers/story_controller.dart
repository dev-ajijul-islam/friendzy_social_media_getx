import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  final TextEditingController captionController = TextEditingController();
  final storiesByUser = <StoryModel>[].obs;

  final User user = FirebaseServices.auth.currentUser!;

  RxBool isLoading = false.obs;
  RxBool isReacting = false.obs;

  final RxInt currentUserIndex = 0.obs;
  final RxDouble progress = 0.0.obs;
  final RxList<String> selectedImages = <String>[].obs;

  Timer? _timer;
  final storyDuration = const Duration(seconds: 20);

  @override
  void onInit() {
    super.onInit();
    getAllStories();
  }

  //-----------------GET ALL STORIES------------------
  void getAllStories() {
    FirebaseServices.firestore.collectionGroup("stories").snapshots().listen((
      snapshot,
    ) {
      storiesByUser.value = snapshot.docs
          .map((doc) => StoryModel.fromJson({...doc.data(), "storyId": doc.id}))
          .toList();

      // Reset index if necessary
      if (storiesByUser.isEmpty) {
        currentUserIndex.value = 0;
        _timer?.cancel();
      } else {
        startProgress();
      }
    });
  }

  //------------------ CREATE STORY ------------------
  Future<void> createStory() async {
    if (selectedImages.isEmpty) {
      Get.snackbar(
        "No Images",
        "Please select at least one image for your story",
        snackPosition: SnackPosition.TOP,
      );
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

      Get.snackbar(
        "Success",
        "Story posted successfully",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );

      selectedImages.clear();
      captionController.clear();
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Failed",
        e.message.toString(),
        snackPosition: SnackPosition.TOP,
      );
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

    addViewer();

    if (storiesByUser.isEmpty) return;

    if (currentUserIndex.value < storiesByUser.length - 1) {
      currentUserIndex.value++;
      startProgress();
    }
  }

  void previousUser() {
    _timer?.cancel();

    addViewer();

    if (storiesByUser.isEmpty) return;

    if (currentUserIndex.value > 0) {
      currentUserIndex.value--;
      startProgress();
    }
  }

  //------------------ VIEW + REACT ------------------
  void addViewer() {
    if (currentStory == null) return;

    final me = UserModel(
      email: user.email.toString(),
      fullName: user.displayName!,
      uid: user.uid,
      profilePic: user.photoURL,
    );

    FirebaseServices.firestore
        .collection("users")
        .doc(currentUser?.author.uid)
        .collection("stories")
        .doc(currentUser!.storyId)
        .update({
      "story.viewers": FieldValue.arrayUnion([me.toJson()]),
    });

  }

  void react(bool isMe) {
    if (currentStory == null) return;
    isReacting.value = true;

    final me = UserModel(
      email: user.email!,
      fullName: user.displayName!,
      uid: user.uid,
      profilePic: user.photoURL,
    );

    try {
      isMe
          ? FirebaseServices.firestore
                .collection("users")
                .doc(currentUser?.author.uid)
                .collection("stories")
                .doc(currentUser!.storyId)
                .update({
                  "story.reactors": FieldValue.arrayRemove([me.toJson()]),
                })
          : FirebaseServices.firestore
                .collection("users")
                .doc(currentUser?.author.uid)
                .collection("stories")
                .doc(currentUser!.storyId)
                .update({
                  "story.reactors": FieldValue.arrayUnion([me.toJson()]),
                });
    } on FirebaseException catch (e) {
      Get.snackbar("Failed", e.message.toString());
    } finally {
      isReacting.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
