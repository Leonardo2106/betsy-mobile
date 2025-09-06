import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserRepository {
  UserRepository._();
  static final instance = UserRepository._();
  final _db = FirebaseFirestore.instance;

  // Sem converter para simplificar o set com serverTimestamp
  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> upsert(UserProfile user) async {
    await _doc(user.uid).set(
      user.toMap()..['createdAt'] = FieldValue.serverTimestamp(),
      SetOptions(merge: true),
    );
  }

  Stream<UserProfile?> watch(String uid) {
    return _doc(uid).snapshots().map((d) {
      final data = d.data();
      if (data == null) return null;
      return UserProfile.fromMap(d.id, data);
    });
  }
}
