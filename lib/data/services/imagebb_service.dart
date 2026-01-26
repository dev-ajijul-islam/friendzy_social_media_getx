import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class ImageBBService {
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  static Future<String?> uploadImage(String imagePath) async {
    try {

      final apiKey = "5350a71f27b5f7f75e8d222f343c8cd4";

      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_uploadUrl),
        body: {
          'key': apiKey,
          'image': base64Image,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data']['url'];
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}