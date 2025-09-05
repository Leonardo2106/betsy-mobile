import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ui/ui.dart';
import 'pages/pages.dart';

void main() => runApp(const BetsyApp());

class BetsyApp extends StatelessWidget {
  const BetsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: kGreen, brightness: Brightness.light),
      scaffoldBackgroundColor: Colors.white,
      dividerColor: kDivider,
      appBarTheme: const AppBarTheme(backgroundColor: kGreen, foregroundColor: Colors.white, elevation: 0, centerTitle: true),
      textTheme: GoogleFonts.interTextTheme(),
    );

    return MaterialApp(
      title: 'Betsy',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: base.textTheme.copyWith(
          headlineSmall: base.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      routes: {
        '/': (_) => const HomePage(),
        '/settings': (_) => const SettingsPage(),
        '/profile': (_) => const ProfilePage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/password': (_) => const PasswordPage(),
        '/forgot-email': (_) => const ForgotEmailPage(),
        '/forgot-password': (_) => const ForgotPasswordPage(),
        // items route
        '/activity': (_) => const ActivityPage(),
        '/healthy': (_) => const HealthyPage(),
        '/feeling': (_) => const FeelingPage(),
        '/connection': (_) => const ConnectionPage(),
        '/alert': (_) => const AlertPage(),
      },
      initialRoute: '/login',
    );
  }
}
