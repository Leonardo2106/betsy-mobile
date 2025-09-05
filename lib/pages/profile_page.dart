import 'package:flutter/material.dart';
import '../widgets/green_app_bar.dart';
import '../widgets/betsy_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GreenAppBar(),
      drawer: const BetsyDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 24),
            Center(
              child: CircleAvatar(
                radius: 56,
                backgroundColor: Colors.grey.shade300,
                child: Icon(Icons.person, size: 50, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 18),
            Center(child: Text('USER', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: .6))),
            Center(child: Text('user@email.com', style: TextStyle(color: Colors.grey.shade700))),
            const SizedBox(height: 20),
            const Divider(height: 1),
            _Item(title: 'more info', onTap: () {}),
            const Divider(height: 1),
            _Item(title: 'help', onTap: () {}),
            const Divider(height: 1),
            _Item(title: 'logout', onTap: () => Navigator.pushNamed(context, '/login')),
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
