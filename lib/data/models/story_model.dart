class StoryItem {
  final String id;
  final String image;
  int views;

  StoryItem({required this.id, required this.image, this.views = 0});
}

class StoryUser {
  final String userName;
  final String userImage;
  final List<StoryItem> stories;

  StoryUser({
    required this.userName,
    required this.userImage,
    required this.stories,
  });
}