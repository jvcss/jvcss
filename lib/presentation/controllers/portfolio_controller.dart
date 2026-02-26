import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/animation_constants.dart';

enum PortfolioPhase {
  // Fase 1: Skills
  spheresOrbiting,
  spheresScattering,
  cardsAppearing,
  cardsDisplayed,
  // Fase 2: Identidade
  cardsConverging,
  spheresMerging,
  nameRevealing,
  profileRevealed,
  // Fase 3: GitHub
  githubLoading,
  githubDisplayed,
  // Fase 4: IA
  aiAnalyzing,
  aiRevealed,
}

class PortfolioController extends StateNotifier<PortfolioPhase> {
  PortfolioController() : super(PortfolioPhase.spheresOrbiting) {
    _schedulePhases();
  }

  final List<Timer> _timers = [];

  void _schedulePhases() {
    _timers.add(Timer(AnimDelay.sphereScatterStart, () {
      if (mounted) state = PortfolioPhase.spheresScattering;
    }));

    _timers.add(Timer(AnimDelay.cardMorphStart, () {
      if (mounted) state = PortfolioPhase.cardsAppearing;
    }));

    _timers.add(Timer(AnimDelay.cardDisplayStart, () {
      if (mounted) state = PortfolioPhase.cardsDisplayed;
    }));

    _timers.add(Timer(AnimDelay.cardConvergeStart, () {
      if (mounted) state = PortfolioPhase.cardsConverging;
    }));

    _timers.add(Timer(AnimDelay.sphereMergeStart, () {
      if (mounted) state = PortfolioPhase.spheresMerging;
    }));

    _timers.add(Timer(AnimDelay.nameRevealStart, () {
      if (mounted) state = PortfolioPhase.nameRevealing;
    }));

    _timers.add(Timer(AnimDelay.profileRevealStart, () {
      if (mounted) state = PortfolioPhase.profileRevealed;
    }));

    // Fase 3: GitHub (16s após inicio)
    _timers.add(Timer(const Duration(seconds: 16), () {
      if (mounted) state = PortfolioPhase.githubLoading;
    }));

    _timers.add(Timer(const Duration(seconds: 19), () {
      if (mounted) state = PortfolioPhase.githubDisplayed;
    }));

    // Fase 4: IA (23s após inicio)
    _timers.add(Timer(const Duration(seconds: 23), () {
      if (mounted) state = PortfolioPhase.aiAnalyzing;
    }));
  }

  /// Chamado pela home_page quando a resposta da IA chegar.
  void markAiRevealed() {
    if (mounted && state == PortfolioPhase.aiAnalyzing) {
      state = PortfolioPhase.aiRevealed;
    }
  }

  void restart() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
    state = PortfolioPhase.spheresOrbiting;
    _schedulePhases();
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    super.dispose();
  }
}

final portfolioProvider =
    StateNotifierProvider<PortfolioController, PortfolioPhase>(
  (ref) => PortfolioController(),
);
