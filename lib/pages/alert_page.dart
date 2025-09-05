import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Alert',
      children: const [
        Divider(height: 1),
        ListTile(title: Text('Send an alert')),
        Divider(height: 1),
        ListTile(title: Text('History')),
        Divider(height: 1),
        ListTile(title: Text('Settings')),
        Divider(height: 1),
      ],
    );
  }
}
