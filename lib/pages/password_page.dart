import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/ui.dart';
import '../widgets/betsy_logo.dart';
import '../services/auth_service.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  bool _loading = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(String email) async {
  if (!(_formKey.currentState?.validate() ?? false)) return;

  setState(() => _loading = true);
  try {
    await AuthService.instance.signInWithEmail(
      email: email,
      password: _passCtrl.text.trim(),
    );
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
  } on FirebaseAuthException catch (e) {
    final code = e.code;
    String msg;
    switch (code) {
      case 'user-not-found':
        msg = 'No account found for $email';
        break;
      case 'wrong-password':
        msg = 'Wrong password';
        break;
      case 'invalid-credential':
        msg = 'Invalid credentials';
        break;
      default:
        msg = e.message ?? 'Login error';
    }

    if (!mounted) return;
    // Se não existe conta, ofereça registrar
    if (code == 'user-not-found') {
      final go = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Create account?'),
          content: Text('No account found for $email. Do you want to create one?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Create')),
          ],
        ),
      );
      if (go == true && mounted) {
        Navigator.pushReplacementNamed(context, '/register', arguments: email);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
    }
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final email = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';

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
                    'ENTER PASSWORD',
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
                    'for $email',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.white.withOpacity(.9)),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.mail_outline, color: kGreen),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(email,
                              style: const TextStyle(
                                color: kGreen,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Change', style: TextStyle(color: kGreen)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TextFormField(
                        controller: _passCtrl,
                        obscureText: !_showPass,
                        validator: (v) =>
                            (v != null && v.length >= 6) ? null : 'Min. 6 characters',
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'password...',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPass ? Icons.visibility_off : Icons.visibility,
                              color: kGreen,
                            ),
                            onPressed: () => setState(() => _showPass = !_showPass),
                          ),
                        ),
                        onFieldSubmitted: (_) => _submit(email),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/forgot-password', arguments: email),
                      child: Text('Forgot your password?',
                          style: TextStyle(color: Colors.white.withOpacity(.95))),
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
                    onPressed: _loading ? null : () => _submit(email),
                    child: Text(_loading ? 'Logging in...' : 'Log in',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
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
