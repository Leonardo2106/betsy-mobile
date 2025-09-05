import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/ui.dart';
import '../widgets/betsy_logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: kGreen,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BetsyLogo(size: 48),
                  const SizedBox(height: 36),
                  Text('WELCOME',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 20),
                  Text('Enter your email to continue.', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white.withOpacity(.9))),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(border: InputBorder.none, hintText: 'email...'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(onPressed: () => Navigator.pushNamed(context, '/forgot-email'), child: Text('Forgot your email?', style: TextStyle(color: Colors.white.withOpacity(.95)))),
                  ),
                  const SizedBox(height: 12),
                  _WhitePillButton(label: 'Continue', onPressed: () => Navigator.pushNamed(context, '/password')),
                  const SizedBox(height: 10),
                  _WhitePillButton(label: 'Create an account', onPressed: () => Navigator.pushNamed(context, '/register')),
                  const SizedBox(height: 10),
                  TextButton(onPressed: () {}, child: const Text('Help.', style: TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WhitePillButton extends StatelessWidget {
  const _WhitePillButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: kGreen, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(vertical: 20), elevation: 0),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

