import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDatasource {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFoodImage(File imageFile, String fileName) async {
    try {
      final ref = _storage.ref().child('food_images/$fileName');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> deleteFoodImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
