import 'package:cloud_firestore/cloud_firestore.dart'; // para Timestamp

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final DateTime? createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'createdAt': createdAt, // Firestore aceita DateTime/Timestamp
      };

  factory UserProfile.fromMap(String uid, Map<String, dynamic> m) {
    final raw = m['createdAt'];
    DateTime? created;
    if (raw is Timestamp) {
      created = raw.toDate();
    } else if (raw is DateTime) {
      created = raw;
    }
    return UserProfile(
      uid: uid,
      name: (m['name'] ?? '') as String,
      email: (m['email'] ?? '') as String,
      createdAt: created,
    );
  }
}
