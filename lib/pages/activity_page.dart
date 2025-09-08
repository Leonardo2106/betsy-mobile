import 'package:betsy/data/repos/home_event_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../ui/ui.dart';
import '../widgets/section_scaffold.dart';
import '../data/models/home_event.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool _simulating = false;

  Future<void> _simulate(String uid) async {
    if (_simulating) return;
    setState(() => _simulating = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Simulando eventos por ~45s...')),
    );
    try {
      await HomeEventRepository.instance.simulateDemo(uid, seconds: 45);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Simulação concluída ✅')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falhou a simulação: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _simulating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return SectionScaffold(
      title: 'ESPHome Events',
      children: [
        if (uid == null)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Faça login para ver seus eventos.'),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _simulating ? null : () => _simulate(uid),
                  icon: _simulating
                      ? const SizedBox(
                          width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.play_arrow_rounded),
                  label: Text(_simulating ? 'Simulando...' : 'Simular'),
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<HomeEvent>>(
                stream: HomeEventRepository.instance.recent(uid, limit: 60),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Erro ao carregar: ${snap.error}'),
                    );
                  }
                  final items = snap.data ?? const <HomeEvent>[];
                  if (items.isEmpty) {
                    return _empty();
                  }
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) => _EventTile(e: items[i]),
                  );
                },
              ),
            ],
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _empty() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kTile, borderRadius: BorderRadius.circular(16)),
      child: const Row(
        children: [
          Icon(Icons.sensors, size: 28, color: kIconGreen),
          SizedBox(width: 10),
          Expanded(child: Text('Sem eventos ainda. Assim que o PIR ou o som disparar, aparece aqui.')),
        ],
      ),
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.e});
  final HomeEvent e;

  @override
  Widget build(BuildContext context) {
    final when = e.receivedAt ?? e.ts;
    final date = when != null ? DateFormat('dd/MM HH:mm').format(when) : '—';
    final icon = _iconFor(e.type, e.state);
    final title = _titleFor(e);
    final subtitle = '${e.type} → ${e.state}';

    return Container(
      decoration: BoxDecoration(color: kTile, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white, child: Icon(icon, color: kGreen)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
            ]),
          ),
          const SizedBox(width: 8),
          Text(date, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
        ],
      ),
    );
  }

  IconData _iconFor(String type, String state) {
    if (type.startsWith('binary_sensor.') && type.contains('motion')) {
      return state == 'on' ? Icons.motion_photos_on : Icons.motion_photos_pause;
    }
    if (type.startsWith('sensor.') && (type.contains('loudness') || type.contains('sound'))) {
      return Icons.graphic_eq;
    }
    return Icons.sensors;
  }

  String _titleFor(HomeEvent e) {
    if (e.type.startsWith('binary_sensor.') && e.type.contains('motion')) {
      return e.state == 'on' ? 'Movimento detectado' : 'Movimento cessou';
    }
    if (e.type.startsWith('sensor.') && (e.type.contains('loudness') || e.type.contains('sound'))) {
      final val = e.state;
      return 'Pico de som ${val.isNotEmpty ? val : ''}'.trim();
    }
    return 'Evento';
  }
}
