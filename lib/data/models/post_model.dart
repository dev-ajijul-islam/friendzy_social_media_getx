import 'package:friendzy_social_media_getx/data/models/user_model.dart';

class PostModel {
  UserModel author;
  String caption;
  List<String>? images;
  List<String>? hashTags;
  List<String>? likerIds;
  List<String>? commenterIds;
  DateTime createdAt;

  PostModel({
    required this.author,
    required this.caption,
    this.images,
    this.likerIds,
    this.commenterIds,
    this.hashTags,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      author: json["author"],
      caption: json["caption"],
      commenterIds: json["commenterIds"],
      hashTags: json["hashTags"],
      likerIds: json["likerIds"],
      images: json["images"],
      createdAt: json["createdAt"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "author": author.toJson(),
      "caption": caption,
      "commenterIds": commenterIds ?? [],
      "hashTags": hashTags ?? [],
      "likerIds": likerIds ?? [],
      "images": images ?? [],
      "createdAt": createdAt,
    };
  }
}
