import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/green_app_bar.dart';
import '../widgets/betsy_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GreenAppBar(),
      drawer: const BetsyDrawer(),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 18),
            Center(
              child: Text(
                'SETTINGS',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(.72),
                      letterSpacing: .6,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const _Item(title: 'version', trailing: Text('v.1.0')),
            const Divider(height: 1),

            // 🔽 Toggle do Dev Mode
            const _DevModeTile(),

            const Divider(height: 1),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.title, this.trailing, this.onTap});
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

/// Mostra e alterna o campo `users/{uid}.devMode` (Boolean) no Firestore.
/// - Se o usuário não estiver logado, exibe "login required".
/// - Usa StreamBuilder para refletir mudanças em tempo real.
/// - Grava com merge para não sobrescrever outros campos do perfil.
class _DevModeTile extends StatefulWidget {
  const _DevModeTile();

  @override
  State<_DevModeTile> createState() => _DevModeTileState();
}

class _DevModeTileState extends State<_DevModeTile> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const _Item(
        title: 'dev mode',
        trailing: Text('login required'),
      );
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: docRef.snapshots(),
      builder: (context, snap) {
        // Estado de carregamento inicial
        if (snap.connectionState == ConnectionState.waiting) {
          return _Item(
            title: 'dev mode',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('loading…'),
              ],
            ),
          );
        }

        // Lê o valor atual (default false)
        final data = snap.data?.data();
        final enabled = (data?['devMode'] == true);

        return SwitchListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: const Text('dev mode', style: TextStyle(fontSize: 16)),
          subtitle: Text(
            enabled
                ? 'Simulação habilitada (app pode criar eventos source="sim")'
                : 'Desabilitado (apenas backend grava eventos)',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          value: enabled,
          onChanged: _saving ? null : (next) async {
            setState(() => _saving = true);
            try {
              await docRef.set({'devMode': next}, SetOptions(merge: true));
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(next ? 'Dev mode ON' : 'Dev mode OFF'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } catch (e) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Falha ao salvar dev mode: $e')),
              );
            } finally {
              if (mounted) setState(() => _saving = false);
            }
          },
          secondary: _saving
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.developer_mode_rounded),
        );
      },
    );
  }
}
