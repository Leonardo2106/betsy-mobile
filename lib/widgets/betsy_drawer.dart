import 'package:flutter/material.dart';
import '../ui/ui.dart';
import 'betsy_logo.dart';

class BetsyDrawer extends StatelessWidget {
  const BetsyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * .75;
    return Drawer(
      width: width,
      backgroundColor: kGreen,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  const BetsyLogo(),
                  const Spacer(),
                  const Icon(Icons.person_outline, color: Colors.white),
                ],
              ),
            ),
            const Divider(color: Colors.white54, height: 1, thickness: 1),
            const SizedBox(height: 8),
            _DrawerItem(
              icon: Icons.home_filled,
              label: 'HOME',
              selected: true,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
            ),
            _DrawerItem(
              icon: Icons.settings,
              label: 'SETTINGS',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.icon, required this.label, this.selected = false, this.onTap});
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: .6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
