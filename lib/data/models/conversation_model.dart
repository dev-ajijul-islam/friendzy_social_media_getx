import 'package:friendzy_social_media_getx/data/models/message_model.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';

class ConversationModel {
  final String? conversationId;
  final List<UserModel> participants;
  final MessageModel? lastMessage;
  final Map<String, int> unreadCounts;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isMuted;

  ConversationModel({
    this.conversationId,
    required this.participants,
    this.lastMessage,
    this.unreadCounts = const {},
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isMuted = false,
  });

  ConversationModel copyWith({
    String? conversationId,
    List<UserModel>? participants,
    MessageModel? lastMessage,
    Map<String, int>? unreadCounts,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isMuted,
  }) {
    return ConversationModel(
      conversationId: conversationId ?? this.conversationId,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isMuted: isMuted ?? this.isMuted,
    );
  }

  UserModel get otherParticipant {
    final currentUserId = FirebaseServices.auth.currentUser!.uid;
    return participants.firstWhere((user) => user.uid != currentUserId);
  }

  String get title => otherParticipant.fullName;

  String get photo =>
      otherParticipant.profilePic ??
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

  Map<String, dynamic> toJson() => {
    'conversationId': conversationId,
    'participants': participants.map((user) => user.toJson()).toList(),
    'lastMessage': lastMessage?.toJson(),
    'unreadCounts': unreadCounts,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'isPinned': isPinned,
    'isMuted': isMuted,
  };

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        conversationId: json['conversationId'],
        participants: (json['participants'] as List)
            .map((userJson) => UserModel.fromJson(userJson))
            .toList(),
        lastMessage: json['lastMessage'] != null
            ? MessageModel.fromJson(json['lastMessage'])
            : null,
        unreadCounts: Map<String, int>.from(json['unreadCounts'] ?? {}),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
        isPinned: json['isPinned'] ?? false,
        isMuted: json['isMuted'] ?? false,
      );
}
