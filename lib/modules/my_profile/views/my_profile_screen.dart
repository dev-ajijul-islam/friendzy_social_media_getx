import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/post_model.dart';
import 'package:friendzy_social_media_getx/data/models/story_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/get_my_posts_controller.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/get_my_stories_controllers.dart';
import 'package:friendzy_social_media_getx/modules/my_profile/controllers/my_profile_controller.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/routes/app_routes.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyProfileController profileController =
        Get.find<MyProfileController>();
    final GetMyPostsController myPostsController =
        Get.find<GetMyPostsController>();
    final GetMyStoriesControllers myStoriesController =
        Get.find<GetMyStoriesControllers>();
    final UserModel userInfo = profileController.userInfo.value;

    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              userInfo.profilePic != null
                                  ? userInfo.profilePic.toString()
                                  : 'https://i.pravatar.cc/150?u=5',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileController.isProfileInfoLoading.value
                                      ? "--"
                                      : userInfo.fullName.toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  profileController.isProfileInfoLoading.value
                                      ? "--"
                                      : userInfo.email.toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.logout_outlined,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await FirebaseServices.auth.signOut();
                              Get.offAndToNamed(AppRoutes.signInScreen);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        profileController.isProfileInfoLoading.value
                            ? "--"
                            : userInfo.bio != null
                            ? userInfo.bio.toString()
                            : "No bio found",
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.secondary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(AppRoutes.editProfile);
                          },
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats Section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(userInfo.postsCount.toString(), "Posts"),
                      _buildVerticalDivider(),
                      _buildStatItem(
                        userInfo.followingCount.toString(),
                        "Following",
                      ),
                      _buildVerticalDivider(),
                      _buildStatItem(
                        userInfo.followersCount.toString(),
                        "Followers",
                      ),
                    ],
                  ),
                ),

                TabBar(
                  tabs: [
                    Tab(text: "Posts"),
                    Tab(text: "Stories"),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                            ),
                        itemCount: myPostsController.myPosts.length,
                        itemBuilder: (context, index) {
                          if (myPostsController.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (myPostsController.myPosts.isEmpty) {
                            return Center(child: Text("There is no story yet"));
                          }

                          final PostModel post =
                              myPostsController.myPosts[index];

                          return GestureDetector(
                            onTap: () => Get.toNamed(
                              AppRoutes.postDetailsScreen,
                              arguments: post,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: post.images!.isEmpty
                                  ? Card(
                                      child: Center(
                                        child: Text(
                                          post.caption.length > 15
                                              ? "${post.caption.substring(0, 15)}.."
                                              : post.caption,
                                          textAlign: .center,
                                        ),
                                      ),
                                    )
                                  : Card(
                                      clipBehavior: .hardEdge,
                                      child: Image.network(
                                        post.images!.first.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                            ),
                        itemCount: myStoriesController.myStories.length,
                        itemBuilder: (context, index) {
                          if (myStoriesController.isLoading.value) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (myStoriesController.myStories.isEmpty) {
                            return Center(child: Text("There is no story yet"));
                          }

                          final StoryModel story =
                              myStoriesController.myStories[index];

                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.storyDetailsScreen);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: story.story.images.isEmpty
                                  ? Card(
                                      child: Center(
                                        child: Text(
                                          story.story.captions.length > 15
                                              ? "${story.story.captions.substring(0, 15)}.."
                                              : story.story.captions,
                                          textAlign: .center,
                                        ),
                                      ),
                                    )
                                  : Card(
                                      clipBehavior: .hardEdge,
                                      child: Image.network(
                                        story.story.images.first.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
  }
}
