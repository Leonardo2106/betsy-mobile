import 'package:flutter/material.dart';
import '../widgets/section_scaffold.dart';
import '../ui/ui.dart';

class FeelingPage extends StatelessWidget {
  const FeelingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SectionScaffold(
      title: 'Feeling',
      children: [
        const SizedBox(height: 12),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.light)
                ? (kTile) // se tiver kTile
                : scheme.surfaceVariant.withOpacity(.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Text('🧠', style: Theme.of(context).textTheme.titleLarge),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Como você está hoje?',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      'Registre seu humor e acompanhe sua jornada.',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Ações
        _ActionTile(
          title: 'Check In',
          subtitle: 'Anote seu humor agora',
          leading: Icons.edit_note_rounded,
          accent: (kGreen),
          onTap: () => Navigator.pushNamed(context, '/checkin'),
        ),
        _DividerInset(),

        _ActionTile(
          title: 'History',
          subtitle: 'Veja seus últimos registros',
          leading: Icons.calendar_month_rounded,
          accent: (kGreen),
          onTap: () => Navigator.pushNamed(context, '/checkin-history'),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.onTap,
    required this.accent,
  });

  final String title;
  final String subtitle;
  final IconData leading;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: (Theme.of(context).brightness == Brightness.light)
                ? (kTile)
                : scheme.surfaceVariant.withOpacity(.35),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(leading, color: accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          )),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerInset extends StatelessWidget {
  const _DividerInset();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(height: 1),
    );
  }
}
