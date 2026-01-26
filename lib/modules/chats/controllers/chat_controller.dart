import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/models/conversation_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';

class ChatsController extends GetxController {
  final RxInt _currentTab = 0.obs;
  final RxBool _isLoading = false.obs;
  final RxList<UserModel> _allUsers = <UserModel>[].obs;
  final RxList<ConversationModel> _conversations = <ConversationModel>[].obs;
  final RxList<UserModel> _filteredUsers = <UserModel>[].obs;
  final RxList<ConversationModel> _filteredConversations =
      <ConversationModel>[].obs;

  final TextEditingController searchController = TextEditingController();

  int get currentTab => _currentTab.value;
  bool get isLoading => _isLoading.value;
  List<UserModel> get allUsers => _allUsers;
  List<ConversationModel> get conversations => _conversations;
  List<UserModel> get filteredUsers => _filteredUsers;
  List<ConversationModel> get filteredConversations => _filteredConversations;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
    searchController.addListener(_filterData);
  }



  // Tab Management
  void changeTab(int index) {
    _currentTab.value = index;
    _filterData();
  }

  // Load Data
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
          _filteredUsers.value = _allUsers;
        });
  }

  Future<void> _loadConversations() async {
    final currentUserId = FirebaseServices.auth.currentUser!.uid;

    FirebaseServices.firestore
        .collection("conversations")
        .snapshots() // Remove the where clause
        .listen((snapshot) {
      // Filter conversations client-side
      final conversations = snapshot.docs
          .map((doc) {
        final data = doc.data();
        final participants = List<Map<String, dynamic>>.from(data['participants'] ?? []);

        // Check if current user is in participants
        bool hasCurrentUser = participants.any((p) => p['uid'] == currentUserId);

        if (hasCurrentUser) {
          return ConversationModel.fromJson(data);
        }
        return null;
      })
          .where((conv) => conv != null)
          .cast<ConversationModel>()
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      _conversations.value = conversations;
      _filteredConversations.value = conversations;
    });
  }

  // Search Filtering
  void _filterData() {
    final query = searchController.text.toLowerCase();

    if (currentTab == 0) {
      // Filter users
      if (query.isEmpty) {
        _filteredUsers.value = _allUsers;
      } else {
        _filteredUsers.value = _allUsers
            .where(
              (user) =>
                  user.fullName.toLowerCase().contains(query) ||
                  user.email.toLowerCase().contains(query),
            )
            .toList();
      }
    } else {
      // Filter conversations
      if (query.isEmpty) {
        _filteredConversations.value = _conversations;
      } else {
        _filteredConversations.value = _conversations
            .where(
              (conv) =>
                  conv.otherParticipant.fullName.toLowerCase().contains(
                    query,
                  ) ||
                  conv.lastMessage?.content.text?.toLowerCase().contains(
                        query,
                      ) ==
                      true,
            )
            .toList();
      }
    }
  }

  // Clear Search
  void clearSearch() {
    searchController.clear();
  }

  // Check if user has conversation
  Future<bool> hasConversationWith(String userId) async {

    final currentUserId = FirebaseServices.auth.currentUser!.uid;
    final query = await FirebaseServices.firestore
        .collection("conversations")
        .where('participantIds', arrayContains: currentUserId)
        .get();

    return query.docs.any((doc) {
      final participants = List<String>.from(
        doc.data()['participantIds'] ?? [],
      );
      return participants.contains(userId) && participants.length == 2;
    });
  }

  // Get existing conversation ID with user
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
