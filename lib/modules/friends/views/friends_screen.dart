import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/followers_controllers.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/following_controllers.dart';
import 'package:friendzy_social_media_getx/modules/friends/controllers/friends_controllers.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsController = Get.find<FriendsControllers>();
    final followingController = Get.find<FollowingControllers>();
    final followersController = Get.find<FollowersControllers>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: _buildTabView(
          friendsController,
          followersController,
          followingController,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: Get.back,
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
          Tab(text: "All Users"),
          Tab(text: "Followers"),
          Tab(text: "Following"),
        ],
      ),
    );
  }

  TabBarView _buildTabView(
    FriendsControllers friendsController,
    FollowersControllers followersController,
    FollowingControllers followingController,
  ) {
    return TabBarView(
      children: [
        _AllUsersTab(friendsController: friendsController),
        _FollowersTab(
          followersController: followersController,
          friendsController: friendsController,
        ),
        _FollowingTab(
          followingController: followingController,
          friendsController: friendsController,
        ),
      ],
    );
  }
}

class _AllUsersTab extends StatelessWidget {
  final FriendsControllers friendsController;

  const _AllUsersTab({required this.friendsController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _TabContent(
        title: friendsController.searchController.text.isNotEmpty
            ? 'Search Results'
            : 'All Users',
        count: friendsController.filteredUsers.length.toString(),
        users: friendsController.filteredUsers,
        showFollowButton: true,
        controller: friendsController,
        searchController: friendsController.searchController,
        totalCount: friendsController.allUsers.length,
      ),
    );
  }
}

class _FollowersTab extends StatelessWidget {
  final FollowersControllers followersController;
  final FriendsControllers friendsController;

  const _FollowersTab({
    required this.followersController,
    required this.friendsController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _TabContent(
        title: followersController.searchController.text.isNotEmpty
            ? 'Search Results'
            : 'Followers',
        count: followersController.filteredFollowers.length.toString(),
        users: followersController.filteredFollowers,
        showFollowButton: true,
        controller: friendsController,
        searchController: followersController.searchController,
        totalCount: followersController.followers.length,
      ),
    );
  }
}

class _FollowingTab extends StatelessWidget {
  final FollowingControllers followingController;
  final FriendsControllers friendsController;

  const _FollowingTab({
    required this.followingController,
    required this.friendsController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _TabContent(
        title: followingController.searchController.text.isNotEmpty
            ? 'Search Results'
            : 'Following',
        count: followingController.filteredFollowing.length.toString(),
        users: followingController.filteredFollowing,
        showFollowButton: true,
        controller: friendsController,
        searchController: followingController.searchController,
        totalCount: followingController.followingUsers.length,
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String title;
  final String count;
  final List<UserModel> users;
  final bool showFollowButton;
  final FriendsControllers controller;
  final TextEditingController searchController;
  final int totalCount;

  const _TabContent({
    required this.title,
    required this.count,
    required this.users,
    required this.showFollowButton,
    required this.controller,
    required this.searchController,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _SearchBox(searchController: searchController),
          _SectionHeader(
            title: title,
            count: count,
            totalCount: totalCount,
            isSearching: searchController.text.isNotEmpty,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: users.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _UserTile(
                          user: user,
                          controller: controller,
                          showFollowButton: showFollowButton,
                        );
                      },
                    ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.people_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            searchController.text.isNotEmpty
                ? 'No users found for "${searchController.text}"'
                : 'No users found',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController searchController;

  const _SearchBox({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Get.theme.colorScheme.secondary.withAlpha(300),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(Icons.search, color: Get.theme.colorScheme.secondary),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search friends...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            if (searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () => searchController.clear(),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String count;
  final int totalCount;
  final bool isSearching;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.totalCount,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                "($count)",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final FriendsControllers controller;
  final bool showFollowButton;

  const _UserTile({
    required this.user,
    required this.controller,
    required this.showFollowButton,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _UserAvatar(profilePic: user.profilePic!),
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
                  user.email,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (showFollowButton) _buildFollowButton(),
        if (showFollowButton) const SizedBox(width: 10),
        _buildViewProfileButton(),
      ],
    );
  }

  Widget _buildFollowButton() {
    return StreamBuilder<bool>(
      stream: controller.isFollowingStream(user.uid!),
      builder: (context, snapshot) {
        final isFollowing = snapshot.data ?? false;
        final isProcessing = controller.loadingUserId.value == user.uid;

        return GestureDetector(
          onTap: isProcessing
              ? null
              : () => controller.toggleFollow(targetUser: user),
          child: _SmallButton(
            label: (isFollowing ? 'Unfollow' : 'Follow'),
            backgroundColor: isFollowing
                ? Colors.grey[300]!
                : Get.theme.colorScheme.secondary,
            textColor: isFollowing ? Colors.black87 : Colors.white,
            isLoading: isProcessing,
          ),
        );
      },
    );
  }

  Widget _buildViewProfileButton() {
    return _SmallButton(
      label: 'View Profile',
      backgroundColor: const Color(0xFFF2F2F2),
      textColor: Colors.black87,
      isLoading: false,
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String profilePic;

  const _UserAvatar({required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey[200],
      backgroundImage: null, // remove NetworkImage
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: profilePic,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const CircularProgressIndicator(strokeWidth: 2),
          errorWidget: (context, url, error) =>
              const Icon(Icons.person, size: 30, color: Colors.grey),
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool isLoading;

  const _SmallButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            )
          : Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
    );
  }
}
