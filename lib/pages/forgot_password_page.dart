import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/ui.dart';
import '../widgets/betsy_logo.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se chegou o email da pagina de login, já deixa o email pronto  
    final argEmail = (ModalRoute.of(context)?.settings.arguments as String?) ?? '';
    if (argEmail.isNotEmpty && _emailCtrl.text.isEmpty) {
      _emailCtrl.text = argEmail;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Chamar API de reset
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reset link sent (UI only)')),
      );
      // Voltar par a tela de senha ou login
      Navigator.pop(context);
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
                    'RESET PASSWORD',
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
                    'Enter your email to receive a reset link.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(color: Colors.white.withOpacity(.9)),
                  ),
                  const SizedBox(height: 18),
                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Enter your email';
                          final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v);
                          return ok ? null : 'Enter a valid email';
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'email...',
                        ),
                      ),
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
                    child: const Text('Send reset link', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/forgot-email'),
                    child: const Text('Forgot your email?', style: TextStyle(color: Colors.white)),
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
