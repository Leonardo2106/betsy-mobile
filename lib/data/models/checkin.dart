import 'package:cloud_firestore/cloud_firestore.dart';

class Checkin {
  final int mood; // 0..4
  final double sleepHours; // ex.: 7.5
  final int energy; // 0..10
  final int stress; // 0..10
  final int waterCups;
  final bool meditated;
  final bool exercised;
  final bool healthyBreakfast;
  final String goals;
  final String gratitude;
  final String notes;
  final DateTime? createdAt;

  Checkin({
    required this.mood,
    required this.sleepHours,
    required this.energy,
    required this.stress,
    required this.waterCups,
    required this.meditated,
    required this.exercised,
    required this.healthyBreakfast,
    this.goals = '',
    this.gratitude = '',
    this.notes = '',
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'mood': mood,
        'sleepHours': sleepHours,
        'energy': energy,
        'stress': stress,
        'waterCups': waterCups,
        'habits': {
          'meditated': meditated,
          'exercised': exercised,
          'healthyBreakfast': healthyBreakfast,
        },
        'goals': goals,
        'gratitude': gratitude,
        'notes': notes,
      };

  factory Checkin.fromMap(Map<String, dynamic> m) {
    final habits = (m['habits'] as Map?) ?? {};
    DateTime? created;
    final raw = m['createdAt'];
    if (raw is Timestamp) created = raw.toDate();
    if (raw is DateTime) created = raw;

    return Checkin(
      mood: (m['mood'] ?? 0) as int,
      sleepHours: ((m['sleepHours'] ?? 0) as num).toDouble(),
      energy: (m['energy'] ?? 0) as int,
      stress: (m['stress'] ?? 0) as int,
      waterCups: (m['waterCups'] ?? 0) as int,
      meditated: (habits['meditated'] ?? false) as bool,
      exercised: (habits['exercised'] ?? false) as bool,
      healthyBreakfast: (habits['healthyBreakfast'] ?? false) as bool,
      goals: (m['goals'] ?? '') as String,
      gratitude: (m['gratitude'] ?? '') as String,
      notes: (m['notes'] ?? '') as String,
      createdAt: created,
    );
  }
}
