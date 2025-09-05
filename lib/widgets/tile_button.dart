import 'package:flutter/material.dart';
import '../ui/ui.dart';

class TileButton extends StatelessWidget {
  const TileButton({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(color: kTile, borderRadius: radius),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 44, color: kIconGreen),
                const SizedBox(height: 10),
                Text(
                  label.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: .6,
                        color: kIconGreen,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
