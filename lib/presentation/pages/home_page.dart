import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../controllers/portfolio_controller.dart';
import '../widgets/orbiting_spheres.dart';
import '../widgets/sequential_morph_grid.dart';
import '../widgets/profile_reveal.dart';
import '../widgets/final_dashboard.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final phase = ref.watch(portfolioProvider);
    final portfolioCtrl = ref.read(portfolioProvider.notifier);

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          const _StarBackground(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _buildPhaseContent(phase, portfolioCtrl),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: _RestartButton(
              onPressed: () => portfolioCtrl.restart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(
      PortfolioPhase phase, PortfolioController ctrl) {
    switch (phase) {
      case PortfolioPhase.spheresOrbiting:
        return const _PhaseOrbiting();

      case PortfolioPhase.spheresScattering:
        return SequentialMorphGrid(
          key: const ValueKey('morphOut'),
          reversing: false,
          onComplete: ctrl.onMorphOutComplete,
        );

      case PortfolioPhase.cardsDisplayed:
        return SequentialMorphGrid(
          key: const ValueKey('cardsDisplayed'),
          showAllCompleted: true,
          onComplete: () {},
        );

      case PortfolioPhase.cardsConverging:
        return SequentialMorphGrid(
          key: const ValueKey('morphIn'),
          reversing: true,
          onComplete: ctrl.onMorphInComplete,
        );

      case PortfolioPhase.spheresMerging:
        return const _PhaseMerging();

      case PortfolioPhase.nameRevealing:
        return const _PhaseNameReveal();

      case PortfolioPhase.profileRevealed:
        return const _PhaseProfileFull();

      case PortfolioPhase.finalDashboard:
        return const FinalDashboard();
    }
  }
}

// ── FASE: esferas orbitando ──────────────────────────────────────────────────
class _PhaseOrbiting extends StatelessWidget {
  const _PhaseOrbiting();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Column(
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
        ),
      ),
    );
  }
}

// ── FASE: esferas fundindo ───────────────────────────────────────────────────
class _PhaseMerging extends StatelessWidget {
  const _PhaseMerging();

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: Center(child: const MergingSphere(key: ValueKey('merging'))),
      );
}

// ── FASE: nome revelando ─────────────────────────────────────────────────────
class _PhaseNameReveal extends StatelessWidget {
  const _PhaseNameReveal();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: const ProfileReveal(
          key: ValueKey('nameReveal'),
          nameVisible: true,
          photoVisible: false,
        ),
      ),
    );
  }
}

// ── FASE: perfil completo ────────────────────────────────────────────────────
class _PhaseProfileFull extends StatelessWidget {
  const _PhaseProfileFull();

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: const ProfileReveal(
          key: ValueKey('profileFull'),
          nameVisible: true,
          photoVisible: true,
        ),
      ),
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
