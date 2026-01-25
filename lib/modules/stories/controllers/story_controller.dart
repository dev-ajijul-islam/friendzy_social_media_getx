import 'dart:async';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  final users = <StoryUser>[].obs;
  final RxInt currentUserIndex = 0.obs;
  final RxInt currentStoryIndex = 0.obs;
  final RxDouble progress = 0.0.obs;

  Timer? _timer;

  final storyDuration = const Duration(seconds: 5);

  @override
  void onInit() {
    super.onInit();

    users.addAll([
      StoryUser(
        userName: "Oyin Dolapo",
        userImage: "https://i.pravatar.cc/150?u=5",
        stories: [
          StoryItem(
            id: "1",
            image:
                "https://images.unsplash.com/photo-1513104890138-7c749659a591",
          ),
          StoryItem(
            id: "2",
            image:
                "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38",
          ),
          StoryItem(
            id: "3",
            image:
                "https://images.unsplash.com/photo-1565958011703-44f9829ba187",
          ),
        ],
      ),
      StoryUser(
        userName: "Chris Martin",
        userImage: "https://i.pravatar.cc/150?u=1",
        stories: [
          StoryItem(
            id: "4",
            image:
                "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
          ),
          StoryItem(
            id: "5",
            image:
                "https://images.unsplash.com/photo-1521305916504-4a1121188589",
          ),
        ],
      ),
      StoryUser(
        userName: "Alex Johnson",
        userImage: "https://i.pravatar.cc/150?u=3",
        stories: [
          StoryItem(
            id: "6",
            image:
                "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe",
          ),
        ],
      ),
    ]);

    startProgress();
  }

  // ------------------ PROGRESS HANDLER ------------------

  void startProgress() {
    _timer?.cancel();
    progress.value = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      progress.value += 0.01;

      if (progress.value >= 1) {
        nextStory();
      }
    });
  }

  // ------------------ STORY NAVIGATION ------------------

  void nextStory() {
    _timer?.cancel();

    final user = users[currentUserIndex.value];

    user.stories[currentStoryIndex.value].views++;

    if (currentStoryIndex.value < user.stories.length - 1) {
      currentStoryIndex.value++;
    } else {
      nextUser();
      return;
    }

    startProgress();
  }

  void previousStory() {
    _timer?.cancel();

    if (currentStoryIndex.value > 0) {
      currentStoryIndex.value--;
    } else {
      previousUser();
      return;
    }

    startProgress();
  }

  // ------------------ USER NAVIGATION ------------------

  void nextUser() {
    if (currentUserIndex.value < users.length - 1) {
      currentUserIndex.value++;
      currentStoryIndex.value = 0;
      startProgress();
    } else {
      Get.back();
    }
  }

  void previousUser() {
    if (currentUserIndex.value > 0) {
      currentUserIndex.value--;
      currentStoryIndex.value = 0;
      startProgress();
    }
  }

  void react() {
    Get.snackbar(
      "Reaction",
      "You reacted to this story ❤️",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
