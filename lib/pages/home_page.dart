import 'package:flutter/material.dart';
import '../widgets/green_app_bar.dart';
import '../widgets/betsy_drawer.dart';
import '../widgets/tile_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GreenAppBar(),
      drawer: const BetsyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.15,
            ),
            children: [
              // TileButton(icon: Icons.groups_2_outlined, label: 'Users', onTap: () {}),
              TileButton(icon: Icons.monitor_heart_outlined, label: 'Activity', onTap: () => Navigator.pushNamed(context, '/activity')),
              // TileButton(icon: Icons.favorite_border, label: 'Healthy', onTap: () => Navigator.pushNamed(context, '/healthy')),
              TileButton(icon: Icons.sentiment_satisfied_alt_outlined, label: 'Feeling', onTap: () => Navigator.pushNamed(context, '/feeling')),
              // TileButton(icon: Icons.device_thermostat, label: 'Temperature', onTap: () {}),
              TileButton(icon: Icons.wifi_tethering, label: 'Connection', onTap: () => Navigator.pushNamed(context, '/connection')),
              // TileButton(icon: Icons.build_outlined, label: 'Tools', onTap: () {}),
              TileButton(icon: Icons.error_outline, label: 'Alert', onTap: () => Navigator.pushNamed(context, '/alert')),
              TileButton(icon: Icons.chat_bubble_outline, label: 'Betsy', onTap: () => Navigator.pushNamed(context, '/chat')),
            ],
          ),
        ),
      ),
    );
  }
}
