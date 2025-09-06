import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class FeelingPage extends StatelessWidget {
  const FeelingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Feeling',
      children: [
        const Divider(height: 1),
        _Item(title: 'Check In', onTap: () => Navigator.pushNamed(context, '/checkin')),
        const Divider(height: 1),
        _Item(title: 'History', onTap: () => Navigator.pushNamed(context, '/checkin-history')),
        const Divider(height: 1),
      ],
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.title, this.trailing, this.onTap});
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
