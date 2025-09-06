import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/green_app_bar.dart';
import '../widgets/betsy_drawer.dart';
import '../data/repos/user_repository.dart';
import '../data/models/user_profile.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // caso extremo (sem sessão): manda pro login
      Future.microtask(() =>
          Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false));
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: const GreenAppBar(),
      drawer: const BetsyDrawer(),
      body: SafeArea(
        child: StreamBuilder<UserProfile?>(
          stream: UserRepository.instance.watch(user.uid),
          builder: (context, snap) {
            final profile = snap.data;
            final displayName = profile?.name ?? user.displayName ?? 'USER';
            final email = profile?.email ?? user.email ?? 'no-email';

            return ListView(
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
                Center(
                  child: Text(
                    displayName.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800, letterSpacing: .6),
                  ),
                ),
                Center(
                  child: Text(email, style: TextStyle(color: Colors.grey.shade700)),
                ),
                const SizedBox(height: 20),
                const Divider(height: 1),
                _Item(title: 'more info', onTap: () {}),
                const Divider(height: 1),
                _Item(title: 'help', onTap: () {}),
                const Divider(height: 1),
                _Item(
                  title: 'logout',
                  trailing: const Icon(Icons.logout),
                  onTap: () async {
                    await AuthService.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
                    }
                  },
                ),
                const Divider(height: 1),
              ],
            );
          },
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
