import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/skills_data.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/orbiting_spheres.dart';
import '../widgets/skill_card.dart';
import '../widgets/profile_reveal.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = ref.watch(portfolioProvider);
    final controller = ref.read(portfolioProvider.notifier);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          // Fundo estrelado
          const _StarBackground(),
          // Conteúdo principal
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: _buildPhaseContent(context, phase),
            ),
          ),
          // Botão de restart (canto inferior direito)
          Positioned(
            bottom: 24,
            right: 24,
            child: _RestartButton(onPressed: controller.restart),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(BuildContext context, PortfolioPhase phase) {
    switch (phase) {
      case PortfolioPhase.spheresOrbiting:
        return const _Phase1Orbiting();
      case PortfolioPhase.spheresScattering:
        return const _Phase1Scattering();
      case PortfolioPhase.cardsAppearing:
      case PortfolioPhase.cardsDisplayed:
        return const _Phase1Cards();
      case PortfolioPhase.cardsConverging:
        return const _Phase2Converging();
      case PortfolioPhase.spheresMerging:
        return const _Phase2Merging();
      case PortfolioPhase.nameRevealing:
        return const _Phase2NameReveal();
      case PortfolioPhase.profileRevealed:
        return const _Phase2ProfileFull();
    }
  }
}

// ── FASE 1.1 – Esferas orbitando no centro ──────────────────────────────────
class _Phase1Orbiting extends StatelessWidget {
  const _Phase1Orbiting();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const OrbitingSpheres(key: ValueKey('orbiting')),
        const SizedBox(height: 32),
        Text(
          'Carregando skills...',
          style: Theme.of(context).textTheme.bodySmall,
        )
            .animate()
            .fadeIn(delay: const Duration(milliseconds: 500))
            .then()
            .shimmer(
              duration: const Duration(seconds: 2),
              color: const Color(0xFFAB47BC),
            ),
      ],
    );
  }
}

// ── FASE 1.2 – Dispersão das esferas ─────────────────────────────────────────
// Reutiliza OrbitingSpheres com estado 'scattering' por simplificação visual;
// a transição real de posição será implementada via AnimatedPositioned na
// home_page quando integrarmos as posições de destino do grid.
class _Phase1Scattering extends StatelessWidget {
  const _Phase1Scattering();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const OrbitingSpheres(key: ValueKey('scattering'), scattering: true),
        const SizedBox(height: 32),
        Text(
          'Organizando skills...',
          style: Theme.of(context).textTheme.bodySmall,
        ).animate().fadeIn(),
      ],
    );
  }
}

// ── FASE 1.3 + 1.4 – Cards das skills ───────────────────────────────────────
class _Phase1Cards extends StatelessWidget {
  const _Phase1Cards();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Skills & Expertise',
            style: Theme.of(context).textTheme.displayMedium,
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: -0.2, end: 0),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: List.generate(kSkills.length, (i) {
              return SkillCard(
                skill: kSkills[i],
                index: i,
              );
            }),
          ),
          if (!isMobile) const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── FASE 2.1 – Cards convergindo (transição visual simples) ──────────────────
class _Phase2Converging extends StatelessWidget {
  const _Phase2Converging();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const OrbitingSpheres(key: ValueKey('converging')),
        const SizedBox(height: 24),
        Text(
          'Formando identidade...',
          style: Theme.of(context).textTheme.bodySmall,
        ).animate().fadeIn(),
      ],
    );
  }
}

// ── FASE 2.2 – Esferas se fundindo ───────────────────────────────────────────
class _Phase2Merging extends StatelessWidget {
  const _Phase2Merging();

  @override
  Widget build(BuildContext context) {
    return const MergingSphere(key: ValueKey('merging'));
  }
}

// ── FASE 2.3 – Revelação do nome ─────────────────────────────────────────────
class _Phase2NameReveal extends StatelessWidget {
  const _Phase2NameReveal();

  @override
  Widget build(BuildContext context) {
    return ProfileReveal(
      key: const ValueKey('nameReveal'),
      nameVisible: true,
      photoVisible: false,
    );
  }
}

// ── FASE 2.4 – Perfil completo ───────────────────────────────────────────────
class _Phase2ProfileFull extends StatelessWidget {
  const _Phase2ProfileFull();

  @override
  Widget build(BuildContext context) {
    return ProfileReveal(
      key: const ValueKey('profileFull'),
      nameVisible: true,
      photoVisible: true,
    );
  }
}

// ── Componentes auxiliares ───────────────────────────────────────────────────

class _RestartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _RestartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Reiniciar animação',
      child: IconButton.filled(
        onPressed: onPressed,
        icon: const Icon(Icons.replay_rounded),
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFAB47BC).withValues(alpha: 0.2),
          foregroundColor: const Color(0xFFAB47BC),
          side: BorderSide(
            color: const Color(0xFFAB47BC).withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _StarBackground extends StatelessWidget {
  const _StarBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarsPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _StarsPainter extends CustomPainter {
  // Estrelas geradas deterministicamente para evitar rebuilds
  static final List<Offset> _positions = List.generate(80, (i) {
    final x = (i * 137.508) % 1.0;
    final y = (i * 97.314 + 0.5) % 1.0;
    return Offset(x, y);
  });

  static final List<double> _sizes = List.generate(80, (i) {
    return 0.8 + (i % 3) * 0.6;
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.25);
    for (int i = 0; i < _positions.length; i++) {
      canvas.drawCircle(
        Offset(_positions[i].dx * size.width, _positions[i].dy * size.height),
        _sizes[i],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => false;
}
