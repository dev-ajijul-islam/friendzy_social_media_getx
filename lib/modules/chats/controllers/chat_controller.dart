import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/models/conversation_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';

class ChatsController extends GetxController {
  final RxBool _isLoading = false.obs;
  final RxList<UserModel> _allUsers = <UserModel>[].obs;
  final RxList<ConversationModel> _conversations = <ConversationModel>[].obs;
  final RxList<UserModel> _filteredUsers = <UserModel>[].obs;
  final RxList<ConversationModel> _filteredConversations =
      <ConversationModel>[].obs;

  final TextEditingController searchController = TextEditingController();

  bool get isLoading => _isLoading.value;
  List<UserModel> get allUsers => _allUsers;
  List<ConversationModel> get conversations => _conversations;
  List<UserModel> get filteredUsers => _filteredUsers;
  List<ConversationModel> get filteredConversations => _filteredConversations;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    searchController.addListener(filterData);
  }

  void _loadInitialData() async {
    _isLoading.value = true;
    await Future.wait([_loadAllUsers(), _loadConversations()]);
    _isLoading.value = false;
  }

  Future<void> _loadAllUsers() async {
    FirebaseServices.firestore
        .collection("users")
        .where('uid', isNotEqualTo: FirebaseServices.auth.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
          _allUsers.value = snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .toList();
          filterData();
        });
  }

  Future<void> _loadConversations() async {
    final currentUserId = FirebaseServices.auth.currentUser!.uid;

    FirebaseServices.firestore.collection("conversations").snapshots().listen((
      snapshot,
    ) {
      final list =
          snapshot.docs
              .map((doc) {
                final data = doc.data();
                final participants = List<Map<String, dynamic>>.from(
                  data['participants'] ?? [],
                );

                final hasCurrentUser = participants.any(
                  (p) => p['uid'] == currentUserId,
                );

                if (hasCurrentUser) {
                  return ConversationModel.fromJson(data);
                }
                return null;
              })
              .whereType<ConversationModel>()
              .toList()
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      _conversations.value = list;
      filterData();
    });
  }

  void filterData() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      _filteredUsers.value = _allUsers;
      _filteredConversations.value = _conversations;
      return;
    }

    _filteredUsers.value = _allUsers
        .where(
          (user) =>
              user.fullName.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query),
        )
        .toList();

    _filteredConversations.value = _conversations
        .where(
          (conv) =>
              conv.otherParticipant.fullName.toLowerCase().contains(query) ||
              conv.lastMessage?.content.text?.toLowerCase().contains(query) ==
                  true,
        )
        .toList();
  }

  void clearSearch() {
    searchController.clear();
    filterData();
  }

  Future<bool> hasConversationWith(String userId) async {
    final currentUserId = FirebaseServices.auth.currentUser!.uid;

    try {
      final query = await FirebaseServices.firestore
          .collection("conversations")
          .get();

      return query.docs.any((doc) {
        final data = doc.data();
        final participants = List<Map<String, dynamic>>.from(
          data['participants'] ?? [],
        );

        bool hasCurrentUser = false;
        bool hasTargetUser = false;

        for (final p in participants) {
          if (p['uid'] == currentUserId) {
            hasCurrentUser = true;
          }
          if (p['uid'] == userId) {
            hasTargetUser = true;
          }
        }

        return hasCurrentUser && hasTargetUser && participants.length == 2;
      });
    } catch (_) {
      return false;
    }
  }

  Future<String?> getConversationIdWith(String userId) async {
    final currentUserId = FirebaseServices.auth.currentUser!.uid;

    final query = await FirebaseServices.firestore
        .collection("conversations")
        .where('participantIds', arrayContains: currentUserId)
        .get();

    for (final doc in query.docs) {
      final participants = List<String>.from(
        doc.data()['participantIds'] ?? [],
      );

      if (participants.contains(userId) && participants.length == 2) {
        return doc.id;
      }
    }
    return null;
  }
}
