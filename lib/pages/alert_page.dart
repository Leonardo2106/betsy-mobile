import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

enum _Status { idle, loading, ok, error }
enum _Action { send, history, settings }
enum _Level { info, warning, critical }

class _AlertPageState extends State<AlertPage> {
  final _rng = Random();

  final Map<_Action, _Status> _status = {
    _Action.send: _Status.idle,
    _Action.history: _Status.idle,
    _Action.settings: _Status.idle,
  };

  _Level _level = _Level.info;

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Alert',
      children: [
        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              FilledButton.icon(
                onPressed: _simulateAll,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Simular tudo'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _resetAll,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8,
            children: [
              _levelChip(_Level.info, 'Info', Icons.info_outline, Colors.blue),
              _levelChip(_Level.warning, 'Warning', Icons.warning_amber_rounded, Colors.orange),
              _levelChip(_Level.critical, 'Critical', Icons.error_rounded, Colors.red),
            ],
          ),
        ),

        const SizedBox(height: 8),
        const Divider(height: 1),

        _tile(
          action: _Action.send,
          title: 'Send an alert',
          subtitle: 'Nível: ${_levelLabel(_level)}',
          leading: Icons.campaign_rounded,
          onTap: () => _run(
            _Action.send,
            'Enviando alerta (${_levelLabel(_level)})...',
            successChance: _level == _Level.critical ? 0.8 : 0.9,
          ),
        ),
        const Divider(height: 1),

        _tile(
          action: _Action.history,
          title: 'History',
          subtitle: 'Carregar últimos alertas',
          leading: Icons.history_rounded,
          onTap: () => _run(_Action.history, 'Carregando histórico...'),
        ),
        const Divider(height: 1),

        _tile(
          action: _Action.settings,
          title: 'Settings',
          subtitle: 'Salvar preferências do alerta',
          leading: Icons.tune_rounded,
          onTap: () => _run(_Action.settings, 'Salvando configurações...'),
        ),
        const Divider(height: 1),
      ],
    );
  }

  // helpers
  Widget _tile({
    required _Action action,
    required String title,
    required String subtitle,
    required IconData leading,
    required VoidCallback onTap,
  }) {
    final st = _status[action]!;

    Widget trailing;
    switch (st) {
      case _Status.idle:
        trailing = const Icon(Icons.play_circle_outline);
        break;
      case _Status.loading:
        trailing = const SizedBox(
          width: 20, height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
        break;
      case _Status.ok:
        trailing = const Icon(Icons.check_circle, color: Colors.green);
        break;
      case _Status.error:
        trailing = const Icon(Icons.error_rounded, color: Colors.redAccent);
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(leading, color: Colors.black87),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: trailing,
      ),
      onTap: st == _Status.loading ? null : onTap,
    );
  }

  Widget _levelChip(_Level lvl, String label, IconData icon, Color color) {
    final selected = _level == lvl;
    return ChoiceChip.elevated(
      selected: selected,
      onSelected: (_) => setState(() => _level = lvl),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: selected ? Colors.white : color),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      avatar: null,
      selectedColor: color,
      labelStyle: TextStyle(color: selected ? Colors.white : null),
    );
  }

  // Ações
  Future<void> _run(_Action action, String loadingText, {double successChance = 0.85}) async {
    setState(() => _status[action] = _Status.loading);
    _showLoadingDialog(loadingText);

    final ok = await _simulateResult(successChance: successChance);

    if (!mounted) return;
    Navigator.of(context).pop();

    setState(() => _status[action] = ok ? _Status.ok : _Status.error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? '✔ $loadingText OK' : '✖ $loadingText falhou'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _simulateAll() async {
    await _run(_Action.send, 'Enviando alerta (${_levelLabel(_level)})...',
        successChance: _level == _Level.critical ? 0.8 : 0.9);
    if (!mounted) return;
    await _run(_Action.history, 'Carregando histórico...');
    if (!mounted) return;
    await _run(_Action.settings, 'Salvando configurações...');
  }

  void _resetAll() {
    setState(() {
      for (final k in _status.keys) {
        _status[k] = _Status.idle;
      }
    });
  }

  // Simulador
  Future<bool> _simulateResult({double successChance = 0.85}) async {
    await Future.delayed(Duration(milliseconds: 900 + _rng.nextInt(900)));
    return _rng.nextDouble() < successChance;
  }

  void _showLoadingDialog(String text) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 3)),
              const SizedBox(width: 16),
              Flexible(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }

  String _levelLabel(_Level l) {
    switch (l) {
      case _Level.info:
        return 'Info';
      case _Level.warning:
        return 'Warning';
      case _Level.critical:
        return 'Critical';
    }
  }
}
