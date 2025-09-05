import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/ui.dart';

class BetsyLogo extends StatelessWidget {
  const BetsyLogo({super.key, this.size = 26, this.white = true});
  final double size;
  final bool white;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/Betsy(2).png',
      height: size + 6,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Text(
        'Betsy',
        style: GoogleFonts.pacifico(
          fontSize: size,
          color: white ? Colors.white : kGreen,
          height: 1,
        ),
      ),
    );
  }
}
