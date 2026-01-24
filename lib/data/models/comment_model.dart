import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';

class CommentModel {
  String? commentId;
  final UserModel postAuthor;
  final UserModel commentAuthor;
  final String postId;
  final String comment;
  final List<String> likerIds;
  final DateTime createdAt;

  CommentModel({
    this.commentId,
    required this.commentAuthor,
    required this.postAuthor,
    required this.postId,
    required this.comment,
    required this.likerIds,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    List<String> stringify(List<dynamic> list) {
      return list.map((e) => e.toString()).toList();
    }

    return CommentModel(
      commentId: json["commentId"],
      commentAuthor: UserModel.fromJson(json["commentAuthor"]),
      postAuthor: UserModel.fromJson(json["postAuthor"]),
      postId: json["postId"],
      comment: json["comment"],
      likerIds: stringify(json["likerIds"]),
      createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "postAuthor": postAuthor.toJson(),
      "commentAuthor": commentAuthor.toJson(),
      "postId": postId,
      "comment": comment,
      "likerIds": likerIds,
      "createdAt": createdAt,
    };
  }
}
