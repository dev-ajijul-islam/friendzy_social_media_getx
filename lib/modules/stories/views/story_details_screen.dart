import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:get/get.dart';

class StoryDetailsScreen extends StatelessWidget {
  StoryDetailsScreen({super.key});

  final StoryController controller = Get.put(StoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final user = controller.currentUser; // StoryModel
        final story = controller.currentStory; // StoryItem

        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity != null) {
              if (details.primaryVelocity! < 0) {
                // Swipe Left → Next User
                controller.nextUser();
              } else if (details.primaryVelocity! > 0) {
                // Swipe Right → Previous User
                controller.previousUser();
              }
            }
          },
          child: Stack(
            children: [
              // ---------------- STORY IMAGE ----------------
              Positioned.fill(
                child: Image.network(story.image, fit: BoxFit.cover),
              ),

              // ---------------- TOP GRADIENT ----------------
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // ---------------- PROGRESS BARS ----------------
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: List.generate(user.stories.length, (index) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: _progressBar(index),
                            ),
                          );
                        }),
                      ),
                    ),

                    // ---------------- USER INFO ----------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.author.profilePic.toString(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            user.author.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),

                          // ----------- VIEW COUNT -----------
                          Row(
                            children: [
                              const Icon(
                                Icons.remove_red_eye,
                                color: Colors.white70,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                story.viewers.length.toString(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),

                          const SizedBox(width: 15),

                          // ----------- REACTION BUTTON -----------
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: controller.react,
                          ),

                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ---------------- CAPTION (OPTIONAL) ----------------
                    if (story.captions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            story.captions,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),

                    // ---------------- COMMENT BOX ----------------
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Send a message",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Icon(Icons.send, color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- TAP ZONES ----------------
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.previousStory,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.nextStory,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ---------------- PROGRESS BAR WIDGET ----------------

  Widget _progressBar(int index) {
    return Obx(() {
      final controller = Get.find<StoryController>();

      double value = 0;

      if (index < controller.currentStoryIndex.value) {
        value = 1;
      } else if (index == controller.currentStoryIndex.value) {
        value = controller.progress.value;
      }

      return Container(
        height: 4,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(4),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      );
    });
  }
}
