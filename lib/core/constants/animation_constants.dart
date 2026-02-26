// Durações de cada fase da animação do portfolio
class AnimDuration {
  // Fase 1
  static const sphereOrbit = Duration(seconds: 2);
  static const sphereScatter = Duration(seconds: 3);
  static const sphereScatterStagger = Duration(milliseconds: 300);
  static const cardMorph = Duration(seconds: 2);
  static const cardDisplay = Duration(seconds: 3);

  // Fase 2
  static const cardConverge = Duration(seconds: 2);
  static const sphereMerge = Duration(seconds: 1);
  static const nameReveal = Duration(seconds: 1);
  static const profileReveal = Duration(seconds: 1);

  // Animações contínuas
  static const spherePulse = Duration(milliseconds: 1500);
  static const cardFloat = Duration(seconds: 2);
  static const orbitalRotation = Duration(seconds: 6);
}

// Delays acumulados para início de cada fase
class AnimDelay {
  static const phase1Start = Duration.zero;
  static const sphereScatterStart = Duration(seconds: 2);
  static const cardMorphStart = Duration(seconds: 5);
  static const cardDisplayStart = Duration(seconds: 7);
  static const cardConvergeStart = Duration(seconds: 10);
  static const sphereMergeStart = Duration(seconds: 12);
  static const nameRevealStart = Duration(seconds: 13);
  static const profileRevealStart = Duration(seconds: 14);
  static const finalDashboardStart = Duration(seconds: 16);
}
