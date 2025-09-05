import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/ui.dart';
import '../widgets/betsy_logo.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});
  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit(String email) {
    if (_formKey.currentState?.validate() ?? false) {
      //  Chamar API de auth
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, $email (UI only)')),
      );
      Navigator.pushReplacementNamed(context, '/');
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
                  // back
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

                  // email !!!somente visual!!!
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.mail_outline, color: kGreen),
                        const SizedBox(width: 8),
                        Expanded(child: Text(email, style: const TextStyle(color: kGreen, fontWeight: FontWeight.w600))),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Change', style: TextStyle(color: kGreen)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // form senha
                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TextFormField(
                        controller: _passCtrl,
                        obscureText: !_showPass,
                        validator: (v) => (v != null && v.length >= 6) ? null : 'Min. 6 characters',
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'password...',
                          suffixIcon: IconButton(
                            icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility, color: kGreen),
                            onPressed: () => setState(() => _showPass = !_showPass),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
                      child: Text('Forgot your password?', style: TextStyle(color: Colors.white.withOpacity(.95))),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // login
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kGreen,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 0,
                    ),
                    onPressed: () => _submit(email),
                    child: const Text('Log in', style: TextStyle(fontWeight: FontWeight.w700)),
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
