import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/checkin.dart';

class CheckinRepository {
  CheckinRepository._();
  static final instance = CheckinRepository._();
  final _db = FirebaseFirestore.instance;

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('checkins');

  Future<void> upsertToday(String uid, Checkin c, {DateTime? now}) async {
    final when = now ?? DateTime.now();
    final dayKey = _key(when);
    final doc = _col(uid).doc(dayKey);

    await doc.set(
      {
        ...c.toMap(),
        'dayKey': dayKey,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<bool> existsToday(String uid, {DateTime? now}) async {
    final dayKey = _key(now ?? DateTime.now());
    final snap = await _col(uid).doc(dayKey).get();
    return snap.exists;
  }

  Stream<List<Checkin>> recent(String uid, {int limit = 30}) {
    return _col(uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => Checkin.fromMap(d.data())).toList());
  }

  Future<Checkin?> getByDay(String uid, DateTime day) async {
    final snap = await _col(uid).doc(_key(day)).get();
    final data = snap.data();
    if (data == null) return null;
    return Checkin.fromMap(data);
  }
}
