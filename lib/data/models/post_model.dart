import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendzy_social_media_getx/data/models/user_model.dart';

class PostModel {
  String? postId;
  UserModel author;
  String caption;
  List<String>? images;
  List<String>? hashTags;
  List<String>? likerIds;
  int? commentsCount;
  DateTime createdAt;

  PostModel({
    this.postId,
    required this.author,
    required this.caption,
    this.images,
    this.likerIds,
    this.commentsCount,
    this.hashTags,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    List<String> stringify(List<dynamic> list) {
      return list.map((l) => l.toString()).toList();
    }

    return PostModel(
      postId: json["postId"],
      author: UserModel.fromJson(json["author"]),
      caption: json["caption"],
      commentsCount: json["commentsCount"],
      hashTags: stringify(json["hashTags"]),
      likerIds: stringify(json["likerIds"]),
      images: stringify(json["images"]),
      createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "author": author.toJson(),
      "caption": caption,
      "commentsCount": commentsCount ?? 0,
      "hashTags": hashTags ?? [],
      "likerIds": likerIds ?? [],
      "images": images ?? [],
      "createdAt": createdAt,
    };
  }
}
