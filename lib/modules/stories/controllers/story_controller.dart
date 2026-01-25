// StoryController updated to use StoryModel & StoryItem (Firebase/JSON ready)

import 'dart:async';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {

  final storiesByUser = <StoryModel>[].obs;

  final RxInt currentUserIndex = 0.obs;
  final RxInt currentStoryIndex = 0.obs;
  final RxDouble progress = 0.0.obs;

  Timer? _timer;

  final storyDuration = const Duration(seconds: 10);

  @override
  void onInit() {
    super.onInit();

    // ------------------ DUMMY DATA (MATCHES StoryModel) ------------------

    storiesByUser.addAll([
      StoryModel(
        author: UserModel(
          fullName: "Rakibul",
          email: "r@gmil.com"
        ),
        stories: [
          StoryItem(
            storyId: '1',
            image:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591',
            captions: 'Pizza time 🍕',
            viewers: [],
            reactors: [],
          ),
          StoryItem(
            storyId: '2',
            image:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',
            captions: 'Dinner vibes',
            viewers: [],
            reactors: [],
          ),
          StoryItem(
            storyId: '3',
            image:
            'https://images.unsplash.com/photo-1565958011703-44f9829ba187',
            captions: 'Sweet cravings',
            viewers: [],
            reactors: [],
          ),
        ],
      ),
      StoryModel(
        author: UserModel(
          email: "c@gmail.com",
          fullName: 'Chris Martin',
          profilePic: 'https://i.pravatar.cc/150?u=1',
        ),
        stories: [
          StoryItem(
            storyId: '4',
            image:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
            captions: 'Food tour',
            viewers: [],
            reactors: [],
          ),
          StoryItem(
            storyId: '5',
            image:
            'https://images.unsplash.com/photo-1521305916504-4a1121188589',
            captions: 'Late night snack',
            viewers: [],
            reactors: [],
          ),
        ],
      ),
      StoryModel(
        author: UserModel(
          email: "u@gmail.com",
          fullName: 'Alex Johnson',
          profilePic: 'https://i.pravatar.cc/150?u=3',
        ),
        stories: [
          StoryItem(
            storyId: '6',
            image:
            'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe',
            captions: 'Healthy life 🥗',
            viewers: [],
            reactors: [],
          ),
        ],
      ),
    ]);

    startProgress();
  }

  // ------------------ HELPERS ------------------

  StoryModel get currentUser => storiesByUser[currentUserIndex.value];

  StoryItem get currentStory =>
      currentUser.stories[currentStoryIndex.value];

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

    _addViewer();

    if (currentStoryIndex.value <
        currentUser.stories.length - 1) {
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
    if (currentUserIndex.value < storiesByUser.length - 1) {
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

  // ------------------ VIEW + REACT ------------------

  void _addViewer() {
    // Replace with logged-in user
    final me = UserModel(
      email: "ajijul@gmail.com",
      fullName: "Ajijul Islam"
    );

    final viewers = currentStory.viewers;

    if (!viewers.any((u) => u.email == me.email)) {
      viewers.add(me);
    }
  }

  void react() {
    final me = UserModel(
      email: "x@gmail.com",
      fullName: 'My Account',
      profilePic: '',
    );

    final reactors = currentStory.reactors;

    if (!reactors.any((u) => u.email == me.email)) {
      reactors.add(me);

      Get.snackbar(
        'Reaction',
        'You reacted to this story ❤️',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Reaction',
        'You already reacted to this story',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

/*
WHAT CHANGED:

- Uses StoryModel instead of StoryUser
- Uses UserModel as author
- Viewers & reactors stored as List<UserModel>
- Getter: currentUser & currentStory for clean UI binding
- Ready for Firebase (toJson / fromJson compatible)
*/
