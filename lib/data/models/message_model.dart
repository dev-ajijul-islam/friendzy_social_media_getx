import 'package:friendzy_social_media_getx/data/models/user_model.dart';

class MessageModel {
  final String? messageId;
  final String conversationId;
  final UserModel sender;
  final MessageContent content;
  final DateTime timestamp;
  final List<String> readBy;
  final MessageStatus status;

  MessageModel({
    this.messageId,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.timestamp,
    this.readBy = const [],
    this.status = MessageStatus.sent,
  });

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'conversationId': conversationId,
    'sender': sender.toJson(),
    'content': content.toJson(),
    'timestamp': timestamp.millisecondsSinceEpoch,
    'readBy': readBy,
    'status': status.name,
  };

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    messageId: json['messageId'],
    conversationId: json['conversationId'],
    sender: UserModel.fromJson(json['sender']),
    content: MessageContent.fromJson(json['content']),
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    readBy: List<String>.from(json['readBy'] ?? []),
    status: MessageStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => MessageStatus.sent,
    ),
  );
}

class MessageContent {
  final String? text;
  final String? imageUrl;
  final MessageType type;

  MessageContent({this.text, this.imageUrl, required this.type})
    : assert(
        (type == MessageType.text && text != null) ||
            (type == MessageType.image && imageUrl != null),
        'Content must match type',
      );

  Map<String, dynamic> toJson() => {
    'text': text,
    'imageUrl': imageUrl,
    'type': type.name,
  };

  factory MessageContent.fromJson(Map<String, dynamic> json) => MessageContent(
    text: json['text'],
    imageUrl: json['imageUrl'],
    type: MessageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => MessageType.text,
    ),
  );
}

enum MessageType { text, image }

enum MessageStatus { sent, delivered, read }
