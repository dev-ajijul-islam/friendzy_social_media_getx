import 'package:friendzy_social_media_getx/data/models/user_model.dart';

class StoryModel {
  final UserModel author;
  final List<StoryItem> stories;

  StoryModel({required this.stories, required this.author});

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      author: UserModel.fromJson(json['author']),
      stories: (json['stories'] as List)
          .map((e) => StoryItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author.toJson(),
      'stories': stories.map((e) => e.toJson()).toList(),
    };
  }
}

class StoryItem {
  final String storyId;
  final String captions;
  final String image;
  final List<UserModel> viewers;
  final List<UserModel> reactors;

  StoryItem({
    required this.image,
    required this.captions,
    required this.viewers,
    required this.reactors,
    required this.storyId,
  });

  factory StoryItem.fromJson(Map<String, dynamic> json) {
    return StoryItem(
      storyId: json['storyId'] ?? '',
      image: json['image'] ?? '',
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
      'storyId': storyId,
      'image': image,
      'captions': captions,
      'viewers': viewers.map((e) => e.toJson()).toList(),
      'reactors': reactors.map((e) => e.toJson()).toList(),
    };
  }
}
