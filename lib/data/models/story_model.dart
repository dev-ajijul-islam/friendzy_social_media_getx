import 'package:friendzy_social_media_getx/data/models/user_model.dart';

class StoryModel {
  final String? storyId;
  final UserModel author;
  final StoryItem story;

  StoryModel({
    required this.story,
    required this.author,
    this.storyId,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      author: UserModel.fromJson(json['author']),
      story: StoryItem.fromJson(json["story"]),
      storyId: json["storyId"],
    );
  }

  Map<String,dynamic> toJson(){
    return {
      "author" : author.toJson(),
      "story" : story.toJson(),
    };
  }
}

class StoryItem {
  final String captions;
  final List<String> images;
  final List<UserModel> viewers;
  final List<UserModel> reactors;

  StoryItem({
    required this.images,
    required this.captions,
    required this.viewers,
    required this.reactors,
  });

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    List<String> stringify(List<dynamic> list) {
      return list.map((e) => e.toString()).toList();
    }

    return StoryItem(
      images: stringify(json['images']),
      captions: json['captions'] ?? '',
      viewers: (json['viewers'] as List? ?? [])
          .map((e) => UserModel.fromJson(e))
          .toList(),
      reactors: (json['reactors'] as List? ?? [])
          .map((e) => UserModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'images': images,
      'captions': captions,
      'viewers': viewers.map((e) => e.toJson()).toList(),
      'reactors': reactors.map((e) => e.toJson()).toList(),
    };
  }
}
