import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repos/checkin_repository.dart';
import '../data/models/checkin.dart';
import '../ui/ui.dart';
import '../widgets/section_scaffold.dart';

class CheckInHistoryPage extends StatelessWidget {
  const CheckInHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return SectionScaffold(
      title: 'Check-in History',
      children: [
        if (uid == null)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('You must be logged in to view your history.'),
          )
        else
          StreamBuilder<List<Checkin>>(
            stream: CheckinRepository.instance.recent(uid, limit: 60),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snap.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Error loading history: ${snap.error}'),
                );
              }
              final items = snap.data ?? const <Checkin>[];
              if (items.isEmpty) {
                return const _EmptyHistory();
              }
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final c = items[i];
                  return _CheckinTile(checkin: c);
                },
              );
            },
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kTile,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.history, size: 28, color: kIconGreen),
          SizedBox(width: 10),
          Expanded(child: Text('No check-ins yet. Start with your first one!')),
        ],
      ),
    );
  }
}

class _CheckinTile extends StatelessWidget {
  const _CheckinTile({required this.checkin});
  final Checkin checkin;

  @override
  Widget build(BuildContext context) {
    final created = checkin.createdAt;
    final dateText = created != null
        ? '${_two(created.day)}/${_two(created.month)}/${created.year}'
        : 'date unknown';

    final mood = checkin.mood.clamp(0, _moods.length - 1);
    final moodData = _moods[mood];

    return Container(
      decoration: BoxDecoration(
        color: kTile,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(moodData.icon, color: kGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dateText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 2),
                Text(moodData.label,
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    _StatChip(icon: Icons.bedtime, text: '${checkin.sleepHours.toStringAsFixed(1)}h'),
                    _StatChip(icon: Icons.bolt, text: 'Energy ${checkin.energy}'),
                    _StatChip(icon: Icons.self_improvement, text: 'Stress ${checkin.stress}'),
                    _StatChip(icon: Icons.water_drop, text: '${checkin.waterCups} cups'),
                    if (checkin.meditated) const _StatChip(icon: Icons.spa, text: 'Meditated'),
                    if (checkin.exercised) const _StatChip(icon: Icons.fitness_center, text: 'Exercise'),
                    if (checkin.healthyBreakfast) const _StatChip(icon: Icons.breakfast_dining, text: 'Healthy BF'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: kGreen),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

class _MoodInfo {
  const _MoodInfo(this.icon, this.label);
  final IconData icon;
  final String label;
}

const _moods = <_MoodInfo>[
  _MoodInfo(Icons.sentiment_very_dissatisfied, 'Very bad'),
  _MoodInfo(Icons.sentiment_dissatisfied, 'Bad'),
  _MoodInfo(Icons.sentiment_neutral, 'OK'),
  _MoodInfo(Icons.sentiment_satisfied, 'Good'),
  _MoodInfo(Icons.sentiment_very_satisfied, 'Great'),
];
