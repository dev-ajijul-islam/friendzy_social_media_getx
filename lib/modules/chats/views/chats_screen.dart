import 'package:flutter/material.dart';
import 'package:friendzy_social_media_getx/modules/chats/controllers/chat_controller.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/data/models/conversation_model.dart';
import 'package:friendzy_social_media_getx/data/models/message_model.dart';
import 'package:friendzy_social_media_getx/modules/chats/views/conversation_screen.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final ChatsController chatsController = Get.find<ChatsController>();

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
            'Chats',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "All Users"),
              Tab(text: "Conversations"),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                child: TextField(
                  controller: chatsController.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search here....',
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 18,
                      color: Colors.grey,
                    ),
                    suffixIcon: chatsController.searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 18,
                              color: Colors.grey,
                            ),
                            onPressed: chatsController.clearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _AllUsersTab(colorScheme: colorScheme),
                  _ConversationsTab(colorScheme: colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllUsersTab extends StatelessWidget {
  final ColorScheme colorScheme;

  const _AllUsersTab({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final ChatsController controller = Get.find<ChatsController>();

    return Obx(() {
      if (controller.isLoading && controller.filteredUsers.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredUsers.isEmpty) {
        return const Center(child: Text('No users found'));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: controller.filteredUsers.length,
        itemBuilder: (context, index) {
          final user = controller.filteredUsers[index];
          return _UserTile(user: user, colorScheme: colorScheme);
        },
      );
    });
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final ColorScheme colorScheme;

  const _UserTile({required this.user, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => ConversationScreen(targetUser: user));
      },
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: CachedNetworkImageProvider(
          user.profilePic?.isNotEmpty == true
              ? user.profilePic!
              : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
        ),
      ),
      title: Text(
        user.fullName,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(color: colorScheme.primary, fontSize: 11),
      ),
      trailing: _buildTrailingButton(),
    );
  }

  Widget _buildTrailingButton() {
    final ChatsController controller = Get.find<ChatsController>();

    return FutureBuilder<bool>(
      future: controller.hasConversationWith(user.uid!),
      builder: (context, snapshot) {
        final hasConv = snapshot.data ?? false;
        return Container(
          constraints: const BoxConstraints(maxWidth: 80),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: hasConv ? Colors.grey[200] : colorScheme.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            hasConv ? 'Message' : 'Start',
            style: TextStyle(
              color: hasConv ? Colors.black : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        );
      },
    );
  }
}

class _ConversationsTab extends StatelessWidget {
  final ColorScheme colorScheme;

  const _ConversationsTab({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final ChatsController controller = Get.find<ChatsController>();

    return Obx(() {
      if (controller.isLoading && controller.filteredConversations.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.filteredConversations.isEmpty) {
        return const Center(child: Text('No conversations yet'));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: controller.filteredConversations.length,
        itemBuilder: (context, index) {
          final conversation = controller.filteredConversations[index];
          return _ConversationTile(
            conversation: conversation,
            colorScheme: colorScheme,
          );
        },
      );
    });
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final ColorScheme colorScheme;

  const _ConversationTile({
    required this.conversation,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        conversation.unreadCounts[FirebaseServices.auth.currentUser!.uid] ?? 0;
    final lastMessage = conversation.lastMessage;
    final isOnline = conversation.otherParticipant.isOnline;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        Get.to(
          () =>
              ConversationScreen(conversationId: conversation.conversationId!),
        );
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: CachedNetworkImageProvider(
              conversation.photo.isNotEmpty
                  ? conversation.photo
                  : "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            ),
          ),
          if (isOnline)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conversation.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      subtitle: Text(
        _getLastMessagePreview(lastMessage),
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
      ),
      trailing: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatTime(conversation.updatedAt),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (unreadCount > 0)
              CircleAvatar(
                radius: 10,
                backgroundColor: colorScheme.primary,
                child: Text(
                  unreadCount > 9 ? '9+' : unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            else
              const Icon(Icons.check, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String _getLastMessagePreview(MessageModel? lastMessage) {
    if (lastMessage == null) return 'Start a conversation';

    return lastMessage.content.type == MessageType.text
        ? (lastMessage.content.text ?? '').length > 30
              ? '${(lastMessage.content.text ?? '').substring(0, 30)}...'
              : lastMessage.content.text ?? ''
        : '📷 Image';
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Just now';
    }
  }
}
