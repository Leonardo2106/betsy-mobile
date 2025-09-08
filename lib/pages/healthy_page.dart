import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class HealthyPage extends StatelessWidget {
  const HealthyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Healthy',
      children: const [
        Divider(height: 1),
        ListTile(title: Text('Water intake')),
        Divider(height: 1),
        ListTile(title: Text('Mood')),
        Divider(height: 1),
      ],
    );
  }
}
