import 'package:flutter/material.dart';
import '../ui/ui.dart';
import 'betsy_logo.dart';

class GreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GreenAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kGreen,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const BetsyLogo(),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () => Navigator.pushNamed(context, '/profile'),
        ),
      ],
    );
  }
}
