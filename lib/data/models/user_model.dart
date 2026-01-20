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
  final DateTime lastSeen;

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
    required this.lastSeen,
  });

  Map<String, dynamic> toMap() => {
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
    'lastSeen': lastSeen.millisecondsSinceEpoch,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] ?? '',
    username: map['username'] ?? '',
    fullName: map['fullName'] ?? '',
    email: map['email'] ?? '',
    profilePic: map['profilePic'] ?? '',
    bio: map['bio'] ?? '',
    region: map['region'] ?? '',
    gender: map['gender'] ?? '',
    followersCount: map['followersCount'] ?? 0,
    followingCount: map['followingCount'] ?? 0,
    postsCount: map['postsCount'] ?? 0,
    isOnline: map['isOnline'] ?? false,
    lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen']),
  );
}
