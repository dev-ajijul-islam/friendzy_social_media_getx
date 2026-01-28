import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/modules/user_profile/controllers/user_profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments;
    final UserProfileController controller = Get.put(UserProfileController(user));

    const Color primaryTeal = Color(0xFF006680);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final UserModel? user = controller.user.value;
          if (user == null) return const Center(child: Text("User not found"));

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey[200],
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.profilePic ??
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                const CircularProgressIndicator(strokeWidth: 2),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.person, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.region ?? "Unknown Location",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user.bio ?? "No bio found",
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Action Buttons: Message + Follow/Unfollow
                      Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.chat_bubble_outline, size: 20),
                              onPressed: () {
                                // TODO: implement message
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Obx(() {
                              bool isFollowing = controller.isFollowing.value;
                              return SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    isFollowing ? Colors.grey.shade300 : primaryTeal,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                   controller.toggleFollow();
                                  },
                                  child: Text(
                                    isFollowing ? 'Following' : 'Follow',
                                    style: TextStyle(
                                      color: isFollowing ? Colors.black87 : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
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
                      _buildStatItem(user.postsCount.toString(), "Posts"),
                      _buildVerticalDivider(),
                      _buildStatItem(user.followingCount.toString(), "Following"),
                      _buildVerticalDivider(),
                      _buildStatItem(user.followersCount.toString(), "Followers"),
                    ],
                  ),
                ),

                // Followers Horizontal List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: const Text(
                    'Followers',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final List<String> names = [
                        "Elijah",
                        "Abdul",
                        "Qudus",
                        "Joe",
                        "Ojogbon",
                        "Chris"
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://i.pravatar.cc/150?u=user$index'),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              names[index % names.length],
                              style:
                              const TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Tabs: Posts & Stories
                const TabBar(
                  tabs: [
                    Tab(text: "Posts"),
                    Tab(text: "Stories"),
                  ],
                ),
                SizedBox(
                  height: 400,
                  child: TabBarView(
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: user.postsCount,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://picsum.photos/200/200?random=$index',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                      GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://picsum.photos/200/200?random=${index + 50}',
                              fit: BoxFit.cover,
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
          );
        }),
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
  }
}
