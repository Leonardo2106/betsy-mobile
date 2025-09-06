import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

import 'pages/pages.dart';
import 'ui/ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GoogleFonts.config.allowRuntimeFetching = false;

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, st) {
    debugPrint('Firebase init falhou (seguindo sem Firebase): $e\n$st');
  }

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}\n${details.stack}');
  };

  runApp(const BetsyApp());
}

class BetsyApp extends StatelessWidget {
  const BetsyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: kGreen, brightness: Brightness.light),
      scaffoldBackgroundColor: Colors.white,
      dividerColor: kDivider,
      appBarTheme: const AppBarTheme(
        backgroundColor: kGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: GoogleFonts.interTextTheme(),
    );

    final theme = base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        titleLarge: base.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );

    return MaterialApp(
      title: 'Betsy',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const AuthGate(),
      routes: {
        '/home': (_) => const HomePage(),
        '/settings': (_) => const SettingsPage(),
        '/profile': (_) => const ProfilePage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/password': (_) => const PasswordPage(),
        '/forgot-password': (_) => const ForgotPasswordPage(),
        '/forgot-email': (_) => const ForgotEmailPage(),
        // Items
        '/activity': (_) => const ActivityPage(),
        '/healthy': (_) => const HealthyPage(),
        '/feeling': (_) => const FeelingPage(),
        '/connection': (_) => const ConnectionPage(),
        '/alert': (_) => const AlertPage(),
        // Services
        '/checkin': (_) => const CheckInPage(),
        '/checkin-history': (_) => const CheckInHistoryPage(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Se o firebase não estiver disponível, caímos no login sem morrer.
    try {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return snap.data == null ? const LoginPage() : const HomePage();
        },
      );
    } catch (_) {
      return const LoginPage();
    }
  }
}
