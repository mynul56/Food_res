import 'dart:io';
import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseStorageDatasource {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<String> uploadFoodImage(File imageFile, String fileName) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final result = await _functions.httpsCallable('uploadImage').call({
        'base64': base64String,
        'path': 'food_images/$fileName',
      });

      return result.data['url'];
    } catch (e) {
      throw Exception('Failed to upload image via backend: $e');
    }
  }

  Future<void> deleteFoodImage(String imageUrl) async {
    try {
      // Note: Backend deleteImage expects a path, not a URL.
      // We might need a helper to extract path from URL or just pass the path.
      // For now, let's assume we pass the path or implement a path extractor.
      final path = imageUrl.split('/').last; // Very naive extractor
      await _functions.httpsCallable('deleteImage').call({
        'path': 'food_images/$path',
      });
    } catch (e) {
      throw Exception('Failed to delete image via backend: $e');
    }
  }
}
