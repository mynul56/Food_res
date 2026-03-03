import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class FirebaseUserDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserEntity?> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserEntity.fromJson(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<void> createUserOrUpdate(UserEntity user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(
            user.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw Exception('Failed to create/update user in Firestore: $e');
    }
  }
}
