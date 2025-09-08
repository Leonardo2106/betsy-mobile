import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

enum _Status { idle, loading, ok, error }
enum _Check { connection, bluetooth, device }

class _ConnectionPageState extends State<ConnectionPage> {
  final _rng = Random();
  final Map<_Check, _Status> _status = {
    _Check.connection: _Status.idle,
    _Check.bluetooth: _Status.idle,
    _Check.device: _Status.idle,
  };

  @override
  Widget build(BuildContext context) {
    return SectionScaffold(
      title: 'Connection',
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              FilledButton.icon(
                onPressed: _verifyAll,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Verificar tudo'),
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
        const Divider(height: 1),
        _tile(
          check: _Check.connection,
          title: 'Connection',
          leading: Icons.wifi_rounded,
          onTap: () => _runCheck(_Check.connection, 'Verificando internet...'),
        ),
        const Divider(height: 1),
        _tile(
          check: _Check.bluetooth,
          title: 'Bluetooth',
          leading: Icons.bluetooth_rounded,
          onTap: () => _runCheck(_Check.bluetooth, 'Procurando dispositivos BLE...'),
        ),
        const Divider(height: 1),
        _tile(
          check: _Check.device,
          title: 'Device status',
          leading: Icons.memory_rounded,
          onTap: () => _runCheck(_Check.device, 'Checando firmware e sensores...'),
        ),
        const Divider(height: 1),
      ],
    );
  }

  // ---------- UI helpers ----------
  Widget _tile({
    required _Check check,
    required String title,
    required IconData leading,
    required VoidCallback onTap,
  }) {
    final st = _status[check]!;
    final subtitle = switch (st) {
      _Status.idle => 'Toque para verificar',
      _Status.loading => 'Verificando...',
      _Status.ok => 'Tudo certo',
      _Status.error => 'Falhou — toque para tentar de novo',
    };

    Widget trailing;
    switch (st) {
      case _Status.idle:
        trailing = const Icon(Icons.play_circle_outline);
        break;
      case _Status.loading:
        trailing = const SizedBox(
          width: 20,
          height: 20,
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
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: trailing,
      ),
      onTap: st == _Status.loading ? null : onTap,
    );
  }

  // ---------- Actions ----------
  Future<void> _runCheck(_Check check, String loadingText) async {
    setState(() => _status[check] = _Status.loading);

    // Abre um dialog de "carregando"
    _showLoadingDialog(loadingText);

    // Simula uma checagem com pequena chance de falha
    final ok = await _simulateResult();

    if (!mounted) return;
    Navigator.of(context).pop(); // fecha o dialog

    setState(() => _status[check] = ok ? _Status.ok : _Status.error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? '✔ $loadingText OK' : '✖ $loadingText falhou'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _verifyAll() async {
    await _runCheck(_Check.connection, 'Verificando internet...');
    if (!mounted) return;
    await _runCheck(_Check.bluetooth, 'Procurando dispositivos BLE...');
    if (!mounted) return;
    await _runCheck(_Check.device, 'Checando firmware e sensores...');
  }

  void _resetAll() {
    setState(() {
      for (final k in _status.keys) {
        _status[k] = _Status.idle;
      }
    });
  }

  // ---------- Simulation ----------
  Future<bool> _simulateResult() async {
    // 0.9–1.8s de espera
    await Future.delayed(Duration(milliseconds: 900 + _rng.nextInt(900)));
    // 85% de chance de sucesso
    return _rng.nextDouble() < 0.85;
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
              const SizedBox(
                width: 24, height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
