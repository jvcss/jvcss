import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/github_stats_provider.dart';
import '../controllers/ai_judgement_provider.dart';
import 'github_chart.dart';
import 'ai_judgement_card.dart';
import 'orbital_skill_spheres.dart';

class FinalDashboard extends ConsumerStatefulWidget {
  const FinalDashboard({super.key});

  @override
  ConsumerState<FinalDashboard> createState() => _FinalDashboardState();
}

class _FinalDashboardState extends ConsumerState<FinalDashboard> {
  bool _showGitHub = false;
  bool _showAI = false;
  bool _aiTriggered = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showGitHub = true);
    });
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (!mounted) return;
      setState(() => _showAI = true);
      _triggerAI();
    });
  }

  void _triggerAI() {
    if (_aiTriggered) return;
    _aiTriggered = true;
    final stats = ref.read(githubStatsProvider).valueOrNull;
    ref.read(aiJudgementProvider.notifier).analyze(
          stats?.recentCommitMessages ?? [],
        );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section 1: Profile with orbiting spheres
          const _ProfileSection()
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.1, end: 0),

          // Section 2: GitHub Chart
          if (_showGitHub) ...[
            const SizedBox(height: 16),
            const _SectionDivider(),
            const _GitHubSection()
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 800))
                .slideY(
                  begin: 0.12,
                  end: 0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                ),
          ],

          // Section 3: AI Judgement
          if (_showAI) ...[
            const SizedBox(height: 8),
            const _SectionDivider(),
            const _AISection()
                .animate()
                .fadeIn(duration: const Duration(milliseconds: 800))
                .slideY(
                  begin: 0.12,
                  end: 0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                ),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }
}

// ── Section 1: Profile ─────────────────────────────────────────────────────────
class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'João Victor Cardoso dos Santos',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'JVCSS',
          style: GoogleFonts.inter(
            color: const Color(0xFFAB47BC),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 32),
        const OrbitalSkillSpheres(),
      ],
    );
  }
}

// ── Section 2: GitHub ─────────────────────────────────────────────────────────
class _GitHubSection extends ConsumerWidget {
  const _GitHubSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(githubStatsProvider);
    return statsAsync.when(
      loading: () => const _SectionLoading(label: 'Carregando GitHub...'),
      error: (e, _) => _SectionError(message: e.toString()),
      data: (stats) => GitHubChart(stats: stats),
    );
  }
}

// ── Section 3: AI ─────────────────────────────────────────────────────────────
class _AISection extends ConsumerWidget {
  const _AISection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final judgement = ref.watch(aiJudgementProvider);
    return AiJudgementCard(judgement: judgement);
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              const Color(0xFFAB47BC).withValues(alpha: 0.5),
              const Color(0xFF42A5F5).withValues(alpha: 0.5),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  final String label;
  const _SectionLoading({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF42A5F5),
            strokeWidth: 2,
          ),
          const SizedBox(height: 16),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  final String message;
  const _SectionError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF5350)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
