import 'package:flutter/material.dart';
import '../widgets/green_app_bar.dart';
import '../widgets/betsy_drawer.dart';
import '../ui/ui.dart';

class SectionScaffold extends StatelessWidget {
  const SectionScaffold({
    super.key,
    required this.title,
    required this.children,
    this.showBack = true,
    this.onBack,
  });

  final String title;
  final List<Widget> children;
  final bool showBack;
  final VoidCallback? onBack;

  void _goBack(BuildContext context) {
    if (onBack != null) {
      onBack!();
      return;
    }
    // Comportamento padrão: voltar para a tela anterior (Home, no seu fluxo)
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      // fallback: volta pro Home
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GreenAppBar(),
      drawer: const BetsyDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 8),
            if (showBack)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  tooltip: 'Back to menu',
                  onPressed: () => _goBack(context),
                  icon: const Icon(Icons.arrow_back, color: kGreen),
                  // estilinho pílula opcional
                  style: IconButton.styleFrom(
                    backgroundColor: kTile,
                    padding: const EdgeInsets.all(8),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            const SizedBox(height: 8),

            // Título da seção
            Center(
              child: Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(.72),
                  letterSpacing: .6,
                ),
              ),
            ),

            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
