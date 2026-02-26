import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/github_stats_model.dart';

// Cores associadas a linguagens de programação
const _langColors = {
  'Dart': Color(0xFF00B4D8),
  'Python': Color(0xFFFFD43B),
  'JavaScript': Color(0xFFF7DF1E),
  'TypeScript': Color(0xFF3178C6),
  'Kotlin': Color(0xFF7F52FF),
  'Swift': Color(0xFFF05138),
  'Go': Color(0xFF00ACD7),
  'Rust': Color(0xFFDEA584),
  'Java': Color(0xFFED8B00),
  'C++': Color(0xFF00599C),
  'Shell': Color(0xFF89E051),
  'HTML': Color(0xFFE34C26),
  'CSS': Color(0xFF563D7C),
};

Color _colorFor(String lang) =>
    _langColors[lang] ?? const Color(0xFF7986CB);

class GitHubChart extends StatelessWidget {
  final GitHubStats stats;

  const GitHubChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final langs = stats.languagePercents.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho de estatísticas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatChip(
                label: 'Commits',
                value: stats.totalCommits.toString(),
                color: const Color(0xFFAB47BC),
              ),
              const SizedBox(width: 16),
              _StatChip(
                label: 'Repositórios',
                value: stats.totalRepos.toString(),
                color: const Color(0xFF42A5F5),
              ),
            ],
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: -0.2, end: 0),
          const SizedBox(height: 32),
          Text(
            'Performance por Linguagem',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
          const SizedBox(height: 6),
          Text(
            'GitHub • ${stats.totalRepos} repositórios analisados',
            style: GoogleFonts.inter(
              color: const Color(0xFF7986CB),
              fontSize: 13,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
          const SizedBox(height: 24),
          ...langs.asMap().entries.map((entry) {
            final i = entry.key;
            final e = entry.value;
            return _LangBar(
              lang: e.key,
              percent: e.value,
              color: _colorFor(e.key),
              index: i,
            );
          }),
        ],
      ),
    );
  }
}

class _LangBar extends StatelessWidget {
  final String lang;
  final double percent;
  final Color color;
  final int index;

  const _LangBar({
    required this.lang,
    required this.percent,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                lang,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${percent.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                // Trilha de fundo
                Container(
                  height: 8,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Barra animada
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percent / 100),
                  duration: Duration(
                    milliseconds: 600 + index * 100,
                  ),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Container(
                      height: 8,
                      width: constraints.maxWidth * value,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.7), color],
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ).animate(delay: Duration(milliseconds: 400 + index * 80)).fadeIn(
            duration: const Duration(milliseconds: 400),
          ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
