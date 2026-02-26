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
  // Fase Final: Dashboard persistente
  finalDashboard,
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

    _timers.add(Timer(AnimDelay.finalDashboardStart, () {
      if (mounted) state = PortfolioPhase.finalDashboard;
    }));
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
