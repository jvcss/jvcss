import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/animation_constants.dart';

enum PortfolioPhase {
  // Fase 1: Skills
  spheresOrbiting,
  spheresScattering, // morfismo sequencial: esferas → cards
  cardsDisplayed,
  // Fase 2: Identidade
  cardsConverging, // morfismo sequencial reverso: cards → esferas
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
    // Apenas o timer inicial: após orbitar por 2s, começa o morfismo sequencial
    _timers.add(Timer(AnimDelay.sphereScatterStart, () {
      if (mounted) state = PortfolioPhase.spheresScattering;
    }));
    // Todos os demais avanços são disparados por callbacks dos widgets de morfismo
  }

  /// Chamado pelo SequentialMorphGrid quando todas as 9 esferas viraram cards.
  void onMorphOutComplete() {
    if (!mounted || state != PortfolioPhase.spheresScattering) return;
    state = PortfolioPhase.cardsDisplayed;
    // Auto-advance após 5s; usuário pode interagir com os cards enquanto isso
    _timers.add(Timer(AnimDuration.cardsDisplay, () {
      if (mounted && state == PortfolioPhase.cardsDisplayed) {
        state = PortfolioPhase.cardsConverging;
      }
    }));
  }

  /// Chamado pelo SequentialMorphGrid quando todos os cards voltaram para esferas.
  void onMorphInComplete() {
    if (!mounted || state != PortfolioPhase.cardsConverging) return;
    state = PortfolioPhase.spheresMerging;
    _scheduleIdentityPhases();
  }

  void _scheduleIdentityPhases() {
    _timers.add(Timer(AnimDuration.sphereMerge, () {
      if (mounted) state = PortfolioPhase.nameRevealing;
    }));
    _timers.add(Timer(AnimDuration.sphereMerge + AnimDuration.nameReveal, () {
      if (mounted) state = PortfolioPhase.profileRevealed;
    }));
    _timers.add(
      Timer(
        AnimDuration.sphereMerge +
            AnimDuration.nameReveal +
            AnimDuration.profileReveal,
        () {
          if (mounted) state = PortfolioPhase.finalDashboard;
        },
      ),
    );
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
