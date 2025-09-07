import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Connection',
      children: const [
        Divider(height: 1),
        ListTile(title: Text('Connection')),
        Divider(height: 1),
        ListTile(title: Text('Bluetooth')),
        Divider(height: 1),
        ListTile(title: Text('Device status')),
        Divider(height: 1),
      ],
    );
  }
}
