import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String image;
  final String message;
  final DateTime createdAt;

  NotificationModel({
    required this.image,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    return NotificationModel(
      image: json["image"],
      message: json["message"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"image": image, "message": message, "createdAt": createdAt};
  }
}
