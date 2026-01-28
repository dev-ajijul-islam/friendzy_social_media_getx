import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/home/controllers/get_all_post_controller.dart';
import 'package:friendzy_social_media_getx/modules/home/widgets/post_card.dart';
import 'package:friendzy_social_media_getx/modules/stories/controllers/story_controller.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final GetAllPostController postController =
        Get.find<GetAllPostController>();
    final StoryController storyController = Get.put(StoryController());

    return SafeArea(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildTopSection(colorScheme),
            const SizedBox(height: 20),
            _buildStoriesSection(storyController),
            _buildFeedSection(colorScheme, postController),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.searchPost);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF006680), width: 1),
                ),
                child: const TextField(
                  autofocus: false,
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: 'Type something ......',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF006680)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
            icon: const Icon(
              Icons.notifications_none_outlined,
              size: 28,
              color: Color(0xFF006680),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesSection(StoryController controller) {
    return Obx(() {
      final stories = controller.storiesByUser;

      return SizedBox(
        height: 220,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 15),
          scrollDirection: Axis.horizontal,
          itemCount: stories.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              final profileUrl = FirebaseServices.auth.currentUser?.photoURL;

              return GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.addStoryScreen),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            width: 95,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: profileUrl == null || profileUrl.isEmpty
                                ? Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person, size: 40),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: profileUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.person),
                                        ),
                                  ),
                          ),
                          const Positioned(
                            bottom: -15,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 17,
                                child: Center(
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        "Your Story",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final storyModel = stories[index - 1];
            final author = storyModel.author;
            final storyItem = storyModel.story;

            final storyImage = storyItem.images.isNotEmpty
                ? storyItem.images.first
                : null;

            final profilePic =
                author.profilePic != null &&
                    author.profilePic != "null" &&
                    author.profilePic!.isNotEmpty
                ? author.profilePic
                : null;

            return GestureDetector(
              onTap: () {
                controller.currentUserIndex.value = index - 1;
                Get.toNamed(AppRoutes.storyDetailsScreen);
                controller.addViewer();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          width: 95,
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                          ),
                          child: storyImage == null
                              ? Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 40),
                                )
                              : CachedNetworkImage(
                                  imageUrl: storyImage,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.image),
                                      ),
                                ),
                        ),
                        Positioned(
                          bottom: -15,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundImage: profilePic == null
                                  ? null
                                  : CachedNetworkImageProvider(profilePic),
                              child: profilePic == null
                                  ? const Icon(Icons.person, size: 18)
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      author.fullName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildFeedSection(
    ColorScheme colorScheme,
    GetAllPostController postController,
  ) {
    return Obx(() {
      if (postController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (postController.posts.isEmpty) {
        return const Center(child: Text("There is no post yet"));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: postController.posts.length,
        itemBuilder: (context, index) {
          final post = postController.posts[index];
          return PostCard(postModel: post);
        },
      );
    });
  }
}
