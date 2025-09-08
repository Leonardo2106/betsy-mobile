import 'package:cloud_firestore/cloud_firestore.dart';

class HomeEvent {
  final String id;
  final String type;
  final String state;
  final DateTime? ts;
  final DateTime? receivedAt;

  HomeEvent({
    required this.id,
    required this.type,
    required this.state,
    this.ts,
    this.receivedAt,
  });

  factory HomeEvent.fromMap(Map<String, dynamic> map, {String id = ''}) {
    DateTime? _toDt(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      return null;
    }

    return HomeEvent(
      id: id,
      type: (map['type'] ?? '') as String,
      state: (map['state'] ?? '') as String,
      ts: _toDt(map['ts']),
      receivedAt: _toDt(map['receivedAt']),
    );
  }
}
