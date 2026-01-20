import 'package:friendzy_social_media_getx/data/models/user_model.dart';
import 'package:friendzy_social_media_getx/data/services/firebase_services.dart';

Future<void> saveUserIfNotExists(UserModel userModel) async {
  final docRef = FirebaseServices.firestore
      .collection("users")
      .doc(userModel.uid);

  final docSnap = await docRef.get();

  if (!docSnap.exists) {
    await docRef.set(userModel.toJson());
  }
}