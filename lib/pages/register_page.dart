import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/ui.dart';
import '../widgets/betsy_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showPass = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Apenas UI: aqui você chamaria seu backend de registro
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created (UI only)')),
      );
      // Exemplo: ir para Home
      Navigator.pushReplacementNamed(context, '/');
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
                  // Back
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
                    'CREATE ACCOUNT',
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
                    'Sign up to get started.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.white.withOpacity(.9)),
                  ),
                  const SizedBox(height: 18),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _PillField(
                          controller: _nameCtrl,
                          hint: 'name...',
                          keyboardType: TextInputType.name,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 10),
                        _PillField(
                          controller: _emailCtrl,
                          hint: 'email...',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Enter your email';
                            final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
                            return ok ? null : 'Enter a valid email';
                          },
                        ),
                        const SizedBox(height: 10),
                        _PillField(
                          controller: _passCtrl,
                          hint: 'password...',
                          obscureText: !_showPass,
                          suffix: IconButton(
                            icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility, color: kGreen),
                            onPressed: () => setState(() => _showPass = !_showPass),
                          ),
                          validator: (v) => (v != null && v.length >= 6) ? null : 'Min. 6 characters',
                        ),
                        const SizedBox(height: 10),
                        _PillField(
                          controller: _confirmCtrl,
                          hint: 'confirm password...',
                          obscureText: !_showConfirm,
                          suffix: IconButton(
                            icon: Icon(_showConfirm ? Icons.visibility_off : Icons.visibility, color: kGreen),
                            onPressed: () => setState(() => _showConfirm = !_showConfirm),
                          ),
                          validator: (v) => (v == _passCtrl.text) ? null : 'Passwords do not match',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Create account
                  _WhitePillButton(label: 'Create account', onPressed: _submit),

                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Already have an account? Log in', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------- helpers ----------
class _PillField extends StatelessWidget {
  const _PillField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: suffix,
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: kGreen,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 14),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

