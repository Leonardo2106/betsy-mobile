import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repos/checkin_repository.dart';
import '../data/models/checkin.dart';
import '../ui/ui.dart';
import '../widgets/section_scaffold.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  // mood: 0..4 (very sad -> very happy)
  int _mood = 3;

  double _sleepHours = 7;
  double _energy = 6;
  double _stress = 4;
  int _waterCups = 4;

  bool _meditated = false;
  bool _exercised = false;
  bool _healthyBreakfast = false;

  bool _saving = false;

  final _goalsCtrl = TextEditingController();
  final _gratitudeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _goalsCtrl.dispose();
    _gratitudeCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in')),
      );
      return;
    }

    if (_saving) return;
    setState(() => _saving = true);

    try {
      final checkin = Checkin(
        mood: _mood,
        sleepHours: _sleepHours,
        energy: _energy.toInt(),
        stress: _stress.toInt(),
        waterCups: _waterCups,
        meditated: _meditated,
        exercised: _exercised,
        healthyBreakfast: _healthyBreakfast,
        goals: _goalsCtrl.text.trim(),
        gratitude: _gratitudeCtrl.text.trim(),
        notes: _notesCtrl.text.trim(),
      );

      await CheckinRepository.instance.createToday(uid, checkin);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-in saved!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save check-in: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Morning Check-in',
      children: [
        _GroupCard(
          title: 'How are you feeling?',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_moodItems.length, (i) {
              final item = _moodItems[i];
              final selected = _mood == i;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(item.icon, size: 18),
                    const SizedBox(width: 6),
                    Text(item.label),
                  ],
                ),
                selected: selected,
                onSelected: (_) => setState(() => _mood = i),
                selectedColor: kTile,
                shape: StadiumBorder(
                  side: BorderSide(color: selected ? kGreen : Colors.grey.shade300),
                ),
              );
            }),
          ),
        ),
        _GroupCard(
          title: 'Today\'s basics',
          child: Column(
            children: [
              _SliderRow(
                label: 'Sleep',
                valueLabel: '${_sleepHours.toStringAsFixed(1)} h',
                child: Slider(
                  value: _sleepHours,
                  min: 0,
                  max: 12,
                  divisions: 24,
                  label: '${_sleepHours.toStringAsFixed(1)} h',
                  activeColor: kGreen,
                  onChanged: (v) => setState(() => _sleepHours = v),
                ),
              ),
              const SizedBox(height: 6),
              _SliderRow(
                label: 'Energy',
                valueLabel: _energy.toStringAsFixed(0),
                child: Slider(
                  value: _energy,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _energy.toStringAsFixed(0),
                  activeColor: kGreen,
                  onChanged: (v) => setState(() => _energy = v),
                ),
              ),
              const SizedBox(height: 6),
              _SliderRow(
                label: 'Stress',
                valueLabel: _stress.toStringAsFixed(0),
                child: Slider(
                  value: _stress,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: _stress.toStringAsFixed(0),
                  activeColor: kGreen,
                  onChanged: (v) => setState(() => _stress = v),
                ),
              ),
              const SizedBox(height: 6),
              _SliderRow(
                label: 'Water',
                valueLabel: '$_waterCups cups',
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _waterCups = (_waterCups - 1).clamp(0, 20)),
                      icon: const Icon(Icons.remove_circle_outline),
                      color: kGreen,
                    ),
                    Expanded(
                      child: Slider(
                        value: _waterCups.toDouble(),
                        min: 0,
                        max: 20,
                        divisions: 20,
                        label: '$_waterCups',
                        activeColor: kGreen,
                        onChanged: (v) => setState(() => _waterCups = v.toInt()),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _waterCups = (_waterCups + 1).clamp(0, 20)),
                      icon: const Icon(Icons.add_circle_outline),
                      color: kGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _GroupCard(
          title: 'Habits',
          child: Column(
            children: [
              SwitchListTile(
                value: _meditated,
                onChanged: (v) => setState(() => _meditated = v),
                title: const Text('Meditation'),
                activeColor: kGreen,
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: _exercised,
                onChanged: (v) => setState(() => _exercised = v),
                title: const Text('Exercise'),
                activeColor: kGreen,
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: _healthyBreakfast,
                onChanged: (v) => setState(() => _healthyBreakfast = v),
                title: const Text('Healthy breakfast'),
                activeColor: kGreen,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        _GroupCard(
          title: 'Goals & notes',
          child: Column(
            children: [
              _PillField(controller: _goalsCtrl, hint: 'today\'s focus...'),
              const SizedBox(height: 8),
              _PillField(controller: _gratitudeCtrl, hint: 'gratitude (optional)...'),
              const SizedBox(height: 8),
              _PillField(controller: _notesCtrl, hint: 'notes...', maxLines: 4),
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: kGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: _saving ? null : _submit,
          child: Text(_saving ? 'Saving...' : 'Send check-in',
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// helpers
class _MoodItem {
  const _MoodItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

const _moodItems = <_MoodItem>[
  _MoodItem(Icons.sentiment_very_dissatisfied, 'Very bad'),
  _MoodItem(Icons.sentiment_dissatisfied, 'Bad'),
  _MoodItem(Icons.sentiment_neutral, 'OK'),
  _MoodItem(Icons.sentiment_satisfied, 'Good'),
  _MoodItem(Icons.sentiment_very_satisfied, 'Great'),
];

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black.withOpacity(.75)),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: kTile,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({required this.label, required this.valueLabel, required this.child});
  final String label;
  final String valueLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(valueLabel, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
        child,
      ],
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({required this.controller, required this.hint, this.maxLines = 1});
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: maxLines > 1 ? 6 : 0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
