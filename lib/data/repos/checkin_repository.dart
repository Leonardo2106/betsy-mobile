import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/checkin.dart';

class CheckinRepository {
  CheckinRepository._();
  static final instance = CheckinRepository._();
  final _db = FirebaseFirestore.instance;

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  CollectionReference<Map<String, dynamic>> _sub(String uid) =>
      _db.collection('users').doc(uid).collection('checkins');

  Future<void> createToday(String uid, Checkin c) async {
    final docId = _key(DateTime.now());
    await _sub(uid).doc(docId).set(
          c.toMap()..['createdAt'] = FieldValue.serverTimestamp(),
          SetOptions(merge: true),
        );
  }

  Stream<List<Checkin>> recent(String uid, {int limit = 30}) {
    return _sub(uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => Checkin.fromMap(d.data())).toList());
  }
}
