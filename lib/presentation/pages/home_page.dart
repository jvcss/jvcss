import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/ai_judgement_model.dart';
import '../controllers/portfolio_controller.dart';
import '../controllers/github_stats_provider.dart';
import '../controllers/ai_judgement_provider.dart';
import '../widgets/orbiting_spheres.dart';
import '../widgets/skill_card.dart';
import '../widgets/profile_reveal.dart';
import '../widgets/github_chart.dart';
import '../widgets/ai_judgement_card.dart';
import '../../data/models/skills_data.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _aiTriggered = false;

  @override
  Widget build(BuildContext context) {
    final phase = ref.watch(portfolioProvider);
    final portfolioCtrl = ref.read(portfolioProvider.notifier);

    // Dispara análise da IA quando entrar na fase aiAnalyzing
    if (phase == PortfolioPhase.aiAnalyzing && !_aiTriggered) {
      _aiTriggered = true;
      final githubAsync = ref.read(githubStatsProvider);
      final commits = githubAsync.valueOrNull?.recentCommitMessages ?? [];
      Future.microtask(() async {
        await ref.read(aiJudgementProvider.notifier).analyze(commits);
        portfolioCtrl.markAiRevealed();
      });
    }

    // Reset do trigger no restart
    if (phase == PortfolioPhase.spheresOrbiting && _aiTriggered) {
      _aiTriggered = false;
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          const _StarBackground(),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: child,
              ),
              child: _buildPhaseContent(phase),
            ),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: _RestartButton(
              onPressed: () {
                _aiTriggered = false;
                portfolioCtrl.restart();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseContent(PortfolioPhase phase) {
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
      case PortfolioPhase.githubLoading:
        return const _Phase3Loading();
      case PortfolioPhase.githubDisplayed:
        return const _Phase3Chart();
      case PortfolioPhase.aiAnalyzing:
        return const _Phase4Analyzing();
      case PortfolioPhase.aiRevealed:
        return const _Phase4Revealed();
    }
  }
}

// ── FASE 1.1 ─────────────────────────────────────────────────────────────────
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

// ── FASE 1.2 ─────────────────────────────────────────────────────────────────
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

// ── FASE 1.3 + 1.4 ───────────────────────────────────────────────────────────
class _Phase1Cards extends StatelessWidget {
  const _Phase1Cards();

  @override
  Widget build(BuildContext context) {
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
              return SkillCard(skill: kSkills[i], index: i);
            }),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── FASE 2.1 ─────────────────────────────────────────────────────────────────
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

// ── FASE 2.2 ─────────────────────────────────────────────────────────────────
class _Phase2Merging extends StatelessWidget {
  const _Phase2Merging();

  @override
  Widget build(BuildContext context) =>
      const MergingSphere(key: ValueKey('merging'));
}

// ── FASE 2.3 ─────────────────────────────────────────────────────────────────
class _Phase2NameReveal extends StatelessWidget {
  const _Phase2NameReveal();

  @override
  Widget build(BuildContext context) {
    return const ProfileReveal(
      key: ValueKey('nameReveal'),
      nameVisible: true,
      photoVisible: false,
    );
  }
}

// ── FASE 2.4 ─────────────────────────────────────────────────────────────────
class _Phase2ProfileFull extends StatelessWidget {
  const _Phase2ProfileFull();

  @override
  Widget build(BuildContext context) {
    return const ProfileReveal(
      key: ValueKey('profileFull'),
      nameVisible: true,
      photoVisible: true,
    );
  }
}

// ── FASE 3: Loading ──────────────────────────────────────────────────────────
class _Phase3Loading extends ConsumerWidget {
  const _Phase3Loading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Inicia o fetch do GitHub assim que esta fase aparece
    ref.watch(githubStatsProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(
          color: Color(0xFF42A5F5),
          strokeWidth: 2,
        ).animate().fadeIn(),
        const SizedBox(height: 20),
        Text(
          'Analisando GitHub...',
          style: Theme.of(context).textTheme.bodySmall,
        ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
      ],
    );
  }
}

// ── FASE 3: Chart ────────────────────────────────────────────────────────────
class _Phase3Chart extends ConsumerWidget {
  const _Phase3Chart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(githubStatsProvider);
    return statsAsync.when(
      loading: () => const _Phase3Loading(),
      error: (e, _) => _ErrorView(message: e.toString()),
      data: (stats) => GitHubChart(
        key: const ValueKey('githubChart'),
        stats: stats,
      ),
    );
  }
}

// ── FASE 4: Analisando ───────────────────────────────────────────────────────
class _Phase4Analyzing extends ConsumerWidget {
  const _Phase4Analyzing();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AiJudgementCard(
      key: const ValueKey('aiAnalyzing'),
      judgement: const AiJudgement(isLoading: true),
    );
  }
}

// ── FASE 4: Revelado ─────────────────────────────────────────────────────────
class _Phase4Revealed extends ConsumerWidget {
  const _Phase4Revealed();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final judgement = ref.watch(aiJudgementProvider);
    return AiJudgementCard(
      key: const ValueKey('aiRevealed'),
      judgement: judgement,
    );
  }
}

// ── Componentes auxiliares ───────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFEF5350), size: 40),
        const SizedBox(height: 12),
        Text(message, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

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
