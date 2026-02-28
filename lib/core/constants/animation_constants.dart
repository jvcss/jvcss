// Durações de cada fase da animação do portfolio
class AnimDuration {
  // Fase 1 — morfismo sequencial
  static const sphereOrbit = Duration(seconds: 2);
  static const sphereTravel = Duration(milliseconds: 700);
  static const sphereMorphShape = Duration(milliseconds: 400);
  static const sphereTravelPause = Duration(milliseconds: 150);
  static const cardsDisplay = Duration(seconds: 5);

  // Fase 2 — identidade
  static const sphereMerge = Duration(seconds: 1);
  static const nameReveal = Duration(seconds: 1);
  static const profileReveal = Duration(seconds: 1);

  // Animações contínuas
  static const spherePulse = Duration(milliseconds: 1500);
  static const orbitalRotation = Duration(seconds: 6);
}

// Delays para fases controladas por timer (apenas o início)
class AnimDelay {
  static const sphereScatterStart = Duration(seconds: 2);
  // Demais avanços são via callback dos widgets de morfismo
}
