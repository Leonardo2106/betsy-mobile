import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/ui.dart';
import '../widgets/betsy_logo.dart';

class ForgotEmailPage extends StatefulWidget {
  const ForgotEmailPage({super.key});
  @override
  State<ForgotEmailPage> createState() => _ForgotEmailPageState();
}

class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Chamar API de 'find account' ou algo do tipo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('If we find your account, we\'ll send recovery info (UI only)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreen,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const BetsyLogo(size: 48),
                  const SizedBox(height: 24),
                  Text(
                    'FIND YOUR ACCOUNT',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your phone (and optionally your name).',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.white.withOpacity(.9)),
                  ),
                  const SizedBox(height: 18),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // phone 
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Enter your phone';
                              final digits = v.replaceAll(RegExp(r'\D'), '');
                              return digits.length >= 8 ? null : 'Enter a valid phone';
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'phone...',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // optional name
                        Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: TextFormField(
                            controller: _nameCtrl,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'name (optional)...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kGreen,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 0,
                    ),
                    onPressed: _submit,
                    child: const Text('Find my account', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('I remember my email. Log in', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
