import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:friendzy_social_media_getx/data/models/message_model.dart';
import 'package:friendzy_social_media_getx/data/services/imagebb_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/models/conversation_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';

class ConversationController extends GetxController {
  // State
  final RxBool _isLoading = false.obs;
  final RxList<MessageModel> _messages = <MessageModel>[].obs;
  final Rx<ConversationModel?> _conversation = Rx<ConversationModel?>(null);
  final Rx<UserModel?> _otherUser = Rx<UserModel?>(null);
  final RxBool _isTyping = false.obs;
  final RxBool _isSending = false.obs;

  // Text Controller
  final TextEditingController messageController = TextEditingController();

  // Conversation Data
  String conversationId;
  final UserModel? targetUser;

  ConversationController({this.conversationId = '', this.targetUser});

  // Getters
  bool get isLoading => _isLoading.value;
  List<MessageModel> get messages => _messages;
  ConversationModel? get conversation => _conversation.value;
  UserModel? get otherUser => _otherUser.value;
  bool get isTyping => _isTyping.value;
  bool get isSending => _isSending.value;

  @override
  void onInit() {
    super.onInit();
    if (conversationId.isNotEmpty) {
      _loadExistingConversation();
    } else if (targetUser != null) {
      _createOrLoadConversation();
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  // Load Existing Conversation
  Future<void> _loadExistingConversation() async {
    _isLoading.value = true;

    // Load conversation data
    final conversationDoc = await FirebaseServices.firestore
        .collection("conversations")
        .doc(conversationId)
        .get();

    if (conversationDoc.exists) {
      _conversation.value = ConversationModel.fromJson(conversationDoc.data()!);
      _otherUser.value = _conversation.value!.otherParticipant;

      // Listen to messages
      _listenToMessages();
    }

    _isLoading.value = false;
  }

  // Create or Load Conversation with User

  Future<void> _createOrLoadConversation() async {
    _isLoading.value = true;
    final currentUser = _getCurrentUser();

    // Check if conversation already exists
    final existingConvId = await _getExistingConversationId(targetUser!.uid!);

    if (existingConvId != null) {
      // Load existing conversation
      conversationId = existingConvId;
      await _loadExistingConversation();
    } else {
      // Create new conversation
      final docRef = FirebaseServices.firestore
          .collection("conversations")
          .doc();

      conversationId = docRef.id;

      final newConversation = ConversationModel(
        conversationId: conversationId,
        participants: [currentUser, targetUser!],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        unreadCounts: {currentUser.uid!: 0, targetUser!.uid!: 0},
      );

      await docRef.set(newConversation.toJson());

      _conversation.value = newConversation;
      _otherUser.value = targetUser;

      _messages.clear();

      _listenToMessages();

      update();
    }

    _isLoading.value = false;
  }

  // Listen to Messages
  void _listenToMessages() {
    FirebaseServices.firestore
        .collection("conversations")
        .doc(conversationId)
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
          _messages.value = snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data()))
              .toList();

          // Mark messages as read
          _markMessagesAsRead();
        }, onError: (error) {});
  }

  // Send Text Message
  Future<void> sendTextMessage() async {
    if (messageController.text.trim().isEmpty || _isSending.value) return;
    _isSending.value = true;
    final text = messageController.text.trim();
    final currentUser = _getCurrentUser();

    try {
      // Create message
      final message = MessageModel(
        conversationId: conversationId,
        sender: currentUser,
        content: MessageContent(text: text, type: MessageType.text),
        timestamp: DateTime.now(),
        readBy: [currentUser.uid!],
      );

      // Save message
      final messageRef = await FirebaseServices.firestore
          .collection("conversations")
          .doc(conversationId)
          .collection("messages")
          .add(message.toJson());

      // Update message with ID
      await messageRef.update({'messageId': messageRef.id});

      // Update conversation
      await _updateConversationAfterMessage(message);

      // Clear input
      messageController.clear();
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message.toString());
    } finally {
      _isSending.value = false;
    }
  }

  // Send Image Message
  Future<void> sendImageMessage() async {
    if (_isSending.value) return;

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    _isSending.value = true;

    try {
      // Upload to ImgBB
      final imageUrl = await ImageBBService.uploadImage(pickedFile.path);

      if (imageUrl != null) {
        final currentUser = _getCurrentUser();

        // Create message
        final message = MessageModel(
          conversationId: conversationId,
          sender: currentUser,
          content: MessageContent(imageUrl: imageUrl, type: MessageType.image),
          timestamp: DateTime.now(),
          readBy: [currentUser.uid!],
        );

        // Save message
        final messageRef = await FirebaseServices.firestore
            .collection("conversations")
            .doc(conversationId)
            .collection("messages")
            .add(message.toJson());

        // Update message with ID
        await messageRef.update({'messageId': messageRef.id});

        // Update conversation
        await _updateConversationAfterMessage(message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send image');
    } finally {
      _isSending.value = false;
    }
  }

  // Update Conversation After Message
  Future<void> _updateConversationAfterMessage(MessageModel message) async {
    if (_otherUser.value == null) {
      // Load other user first
      await _loadConversationData();
    }

    await FirebaseServices.firestore
        .collection("conversations")
        .doc(conversationId)
        .update({
          'lastMessage': message.toJson(),
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
          'unreadCounts.${_otherUser.value!.uid!}': FieldValue.increment(1),
        });
  }

  Future<void> _loadConversationData() async {
    final doc = await FirebaseServices.firestore
        .collection("conversations")
        .doc(conversationId)
        .get();

    if (doc.exists) {
      _conversation.value = ConversationModel.fromJson(doc.data()!);
      _otherUser.value = _conversation.value!.otherParticipant;
    }
  }

  // Mark Messages as Read
  Future<void> _markMessagesAsRead() async {
    final currentUserId = FirebaseServices.auth.currentUser!.uid;
    final unreadMessages = _messages.where(
      (msg) => !msg.readBy.contains(currentUserId),
    );

    if (unreadMessages.isNotEmpty) {
      final batch = FirebaseServices.firestore.batch();

      for (final message in unreadMessages) {
        final messageRef = FirebaseServices.firestore
            .collection("conversations")
            .doc(conversationId)
            .collection("messages")
            .doc(message.messageId);

        batch.update(messageRef, {
          'readBy': FieldValue.arrayUnion([currentUserId]),
          'status': 'read',
        });
      }

      // Update conversation unread count
      final conversationRef = FirebaseServices.firestore
          .collection("conversations")
          .doc(conversationId);

      batch.update(conversationRef, {'unreadCounts.$currentUserId': 0});

      await batch.commit();
    }
  }

  // Helper Methods
  UserModel _getCurrentUser() {
    final user = FirebaseServices.auth.currentUser!;
    return UserModel(
      uid: user.uid,
      fullName: user.displayName ?? 'User',
      email: user.email ?? '',
      profilePic: user.photoURL,
    );
  }

  Future<String?> _getExistingConversationId(String otherUserId) async {
    final currentUserId = FirebaseServices.auth.currentUser!.uid;

    // Query all conversations
    final query = await FirebaseServices.firestore
        .collection("conversations")
        .get();

    for (final doc in query.docs) {
      final data = doc.data();
      final participants = List<Map<String, dynamic>>.from(
        data['participants'] ?? [],
      );

      // Check if both users are in participants
      bool hasCurrentUser = false;
      bool hasOtherUser = false;

      for (final participant in participants) {
        final participantUid = participant['uid'];
        if (participantUid == currentUserId) {
          hasCurrentUser = true;
        }
        if (participantUid == otherUserId) {
          hasOtherUser = true;
        }
      }

      if (hasCurrentUser && hasOtherUser && participants.length == 2) {
        return doc.id;
      }
    }
    return null;
  }

  // Typing Indicator
  void setTyping(bool typing) {
    _isTyping.value = typing;
  }
}
