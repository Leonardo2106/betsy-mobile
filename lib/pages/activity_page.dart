import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Activity',
      children: const [
        Divider(height: 1),
        ListTile(title: Text('Recent activity'), trailing: Icon(Icons.chevron_right)),
        Divider(height: 1),
        ListTile(title: Text('Start workout')),
        Divider(height: 1),
        ListTile(title: Text('History')),
        Divider(height: 1),
      ],
    );
  }
}
