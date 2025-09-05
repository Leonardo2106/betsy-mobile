import 'package:flutter/material.dart';
import '../widgets/green_app_bar.dart';
import '../widgets/betsy_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GreenAppBar(),
      drawer: const BetsyDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 18),
            Center(
              child: Text(
                'SETTINGS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(.72),
                      letterSpacing: .6,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            _Item(title: 'account', onTap: () {}),
            const Divider(height: 1),
            _Item(title: 'notifications', onTap: () {}),
            const Divider(height: 1),
            const _Item(title: 'version', trailing: Text('v.1.0')),
            const Divider(height: 1),
            _Item(title: 'help', onTap: () {}),
            const Divider(height: 1),
          ],
        ),
      ),
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
