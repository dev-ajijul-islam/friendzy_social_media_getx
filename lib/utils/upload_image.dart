import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Future<void> uploadImage() async {
  ImagePicker imagePicker = .new();
  XFile? pickedFile;
  String url;

  Get.bottomSheet(
    Container(
      padding: .all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: .only(topLeft: .circular(20), topRight: .circular(20)),
      ),

      width: .infinity,
      child: Column(
        mainAxisSize: .min,
        spacing: 10,
        crossAxisAlignment: .start,
        children: [
          Text("Upload Image", style: Get.textTheme.titleLarge),
          SizedBox(height: 10),
          Material(
            child: InkWell(
              onTap: () async{
                final pickedImage =await imagePicker.pickImage(source: .gallery);
                pickedFile = pickedImage;
              },
              child: ListTile(
                textColor: Get.theme.colorScheme.primary,
                trailing: Icon(Icons.photo_outlined),
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                tileColor: Get.theme.colorScheme.secondary.withAlpha(50),
                title: Text("Choose from Gallery"),
              ),
            ),
          ),
          Material(
            child: InkWell(
              onTap: () async{
                final pickedImage =await imagePicker.pickImage(source: .camera);
                pickedFile = pickedImage;
              },
              child: ListTile(
                textColor: Get.theme.colorScheme.primary,
                trailing: Icon(Icons.photo_camera_outlined),
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                tileColor: Get.theme.colorScheme.secondary.withAlpha(50),
                title: Text("Take a picture"),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
