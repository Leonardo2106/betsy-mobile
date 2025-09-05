import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class FeelingPage extends StatelessWidget {
  const FeelingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Feeling',
      children: const [
        Divider(height: 1),
        ListTile(title: Text('Mood today')),
        Divider(height: 1),
        ListTile(title: Text('Energy')),
        Divider(height: 1),
        ListTile(title: Text('Stress')),
        Divider(height: 1),
      ],
    );
  }
}
