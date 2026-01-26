class UserModel {
  final String? uid;
  final String? username;
  final String fullName;
  final String email;
  final String? profilePic;
  final String? bio;
  final String? region;
  final String? gender;
  final int followersCount;
  final int followingCount;
  final int postsCount;
  final bool isOnline;
  final DateTime? lastSeen;

  UserModel({
    this.uid,
    this.username,
    required this.fullName,
    required this.email,
    this.profilePic,
    this.bio,
    this.region,
    this.gender,
    this.followersCount = 0,
    this.followingCount = 0,
    this.postsCount = 0,
    this.isOnline = false,
    this.lastSeen,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'username': username,
    'fullName': fullName,
    'email': email,
    'profilePic': profilePic,
    'bio': bio,
    'region': region,
    'gender': gender,
    'followersCount': followersCount,
    'followingCount': followingCount,
    'postsCount': postsCount,
    'isOnline': isOnline,
    'lastSeen': lastSeen?.millisecondsSinceEpoch,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    username: json['username'],
    fullName: json['fullName'],
    email: json['email'],
    profilePic:
        json['profilePic'] ??
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
    bio: json['bio'],
    region: json['region'],
    gender: json['gender'],
    followersCount: json['followersCount'] ?? 0,
    followingCount: json['followingCount'] ?? 0,
    postsCount: json['postsCount'] ?? 0,
    isOnline: json['isOnline'] ?? false,
    lastSeen: DateTime.fromMillisecondsSinceEpoch(
      json['lastSeen'] ?? DateTime.now().millisecondsSinceEpoch,
    ),
  );
}
