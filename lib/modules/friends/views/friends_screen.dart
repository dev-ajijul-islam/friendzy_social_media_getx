import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/following_controllers.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/friends_controllers.dart';
import 'package:get/get.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FriendsControllers friendsControllers =
        Get.find<FriendsControllers>();
    final FollowingControllers followingControllers =
        Get.find<FollowingControllers>();

    const Color primaryTeal = Color(0xFF006680);

    return DefaultTabController(
      length: 3,
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
            'Friends',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "All users"),
              Tab(text: "Followers"),
              Tab(text: "Following"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTab(context, friendsControllers, primaryTeal),
            _buildTab(context, friendsControllers, primaryTeal),
            _buildTab(context, followingControllers, primaryTeal),
          ],
        ),
      ),
    );
  }

  // ---------------- TAB CONTENT ----------------
  Widget _buildTab(BuildContext context, controller, Color primaryTeal) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          _searchBox(primaryTeal),
          _buildSectionHeader(
            "Friend Requests",
            controller.allUsers.length.toString(),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemCount: controller.allUsers.length,
              itemBuilder: (context, index) {
                final UserModel user = controller.allUsers[index];
                return _buildRequestTile(
                  controller: controller,
                  user: user,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SEARCH BOX ----------------
  Widget _searchBox(Color primaryTeal) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryTeal.withAlpha(300)),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search friends...',
            prefixIcon: Icon(Icons.search, color: primaryTeal),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  // ---------------- SECTION HEADER ----------------
  Widget _buildSectionHeader(String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            count,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- REQUEST TILE ----------------
  Widget _buildRequestTile({
    required UserModel user,
    required FriendsControllers controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.profilePic.toString()),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "2 mutual following",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.isLoading.value
                            ? null
                            : controller.toggleFollow(targetUser: user),
                        child: _smallButton(
                          (controller.isLoading.value)
                              ? "Following.."
                              : "Follow",
                          Get.theme.colorScheme.secondary,
                          Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _smallButton(
                        "View profile",
                        const Color(0xFFF2F2F2),
                        Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ---------------- REQUEST TILE ----------------
  Widget _buildFollowerTile({
    required UserModel user,
    required FriendsControllers controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.profilePic.toString()),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "2 mutual following",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.isLoading.value
                            ? null
                            : controller.toggleFollow(targetUser: user),
                        child: _smallButton(
                          (controller.isLoading.value)
                              ? "Following.."
                              : "Follow",
                          Get.theme.colorScheme.secondary,
                          Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _smallButton(
                        "View profile",
                        const Color(0xFFF2F2F2),
                        Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Following TILE ----------------
  Widget _buildFollowingTile({
    required UserModel user,
    required FollowingControllers controller,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.profilePic.toString()),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "2 mutual following",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.isLoading.value
                            ? null
                            : controller.toggleFollow(targetUser: user),
                        child: _smallButton(
                          (controller.isLoading.value)
                              ? "Following.."
                              : "Follow",
                          Get.theme.colorScheme.secondary,
                          Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _smallButton(
                        "View profile",
                        const Color(0xFFF2F2F2),
                        Colors.black87,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- SMALL BUTTON ----------------
  Widget _smallButton(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
