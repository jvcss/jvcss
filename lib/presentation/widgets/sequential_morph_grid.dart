import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/breakpoints.dart';
import '../../data/models/skill_model.dart';
import '../../data/models/skills_data.dart';
import 'animated_sphere.dart';

// ── Constantes internas de timing ────────────────────────────────────────────
const _kTravelMs = 700;
const _kMorphMs = 400;
const _kTotalMs = _kTravelMs + _kMorphMs; // 1100ms por esfera
const _kPauseMs = 150; // pausa após cada morfismo completar
const _kCardW = 160.0;
const _kCardH = 180.0;
const _kCardRadius = 16.0;

// ── Widget público ────────────────────────────────────────────────────────────

/// Centro absoluto da célula [index] no grid 3×3 para o tamanho de tela dado.
/// Mesma lógica usada internamente pelo widget — exposta para reutilização.
Offset morphGridCenter(int index, Size screen) {
  final col = index % 3;
  final row = index ~/ 3;
  const paddingH = 24.0;
  final paddingV = (screen.height * 0.08).clamp(24.0, 60.0);
  final cellW = (screen.width - paddingH * 2) / 3;
  final cellH = (screen.height - paddingV * 2) / 3;
  return Offset(
    paddingH + cellW * col + cellW / 2,
    paddingV + cellH * row + cellH / 2,
  );
}

/// Anima as 9 esferas de habilidade em um morfismo sequencial:
/// - [reversing] = false: esferas saem da órbita e viram cards em grid 3×3
/// - [reversing] = true : cards viram esferas e convergem para o centro
/// - [showAllCompleted] = true: exibe todos os 9 cards imediatamente (sem animação)
class SequentialMorphGrid extends StatefulWidget {
  final bool reversing;
  final bool showAllCompleted;
  final VoidCallback onComplete;

  const SequentialMorphGrid({
    super.key,
    this.reversing = false,
    this.showAllCompleted = false,
    required this.onComplete,
  });

  @override
  State<SequentialMorphGrid> createState() => _SequentialMorphGridState();
}

class _SequentialMorphGridState extends State<SequentialMorphGrid>
    with TickerProviderStateMixin {
  late AnimationController _orbitController;
  late AnimationController _travelController;

  // Índice da esfera/card que já completou o morfismo.
  // morph-out : 0 = nenhuma colocada → 9 = todas colocadas
  // morph-in  : 9 = todas como card → 0 = todas de volta
  int _completedCount = 0;

  // Indica se uma animação de voo+morfismo está em curso agora.
  bool _isAnimating = false;

  // Posição de partida da esfera/card atual (relativa ao centro da tela).
  Offset? _travelStart;

  // Guarda o tamanho da tela para calcular posições fora do LayoutBuilder.
  Size _screenSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _travelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _kTotalMs),
    );

    if (widget.reversing || widget.showAllCompleted) {
      _completedCount = kSkills.length; // começa com todos como card
    }

    // Modo estático: não anima, apenas exibe todos os cards.
    if (widget.showAllCompleted) return;

    // Pequeno delay para o widget se renderizar antes de iniciar a sequência.
    Future.delayed(const Duration(milliseconds: 400), _startNext);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _travelController.dispose();
    super.dispose();
  }

  // ── Lógica sequencial ────────────────────────────────────────────────────

  void _startNext() {
    if (!mounted) return;

    if (!widget.reversing && _completedCount >= kSkills.length) {
      widget.onComplete();
      return;
    }
    if (widget.reversing && _completedCount <= 0) {
      widget.onComplete();
      return;
    }

    final idx = widget.reversing ? _completedCount - 1 : _completedCount;

    // Captura posição inicial relativa ao centro da tela.
    if (!widget.reversing) {
      // Morph-out: parte da posição orbital atual da esfera.
      final angle = _orbitController.value * 2 * pi +
          (idx / kSkills.length) * 2 * pi;
      final r = orbitRadius(_screenSize.width);
      _travelStart = Offset(cos(angle) * r, sin(angle) * r);
    } else {
      // Morph-in: parte do centro do card no grid.
      final gridCenter = _gridCenter(idx, _screenSize);
      final screenCenter = Offset(
        _screenSize.width / 2,
        _screenSize.height / 2,
      );
      _travelStart = gridCenter - screenCenter;
    }

    setState(() => _isAnimating = true);

    _travelController.forward(from: 0).then((_) {
      Timer(const Duration(milliseconds: _kPauseMs), () {
        if (!mounted) return;
        setState(() {
          if (widget.reversing) {
            _completedCount--;
          } else {
            _completedCount++;
          }
          _isAnimating = false;
          _travelStart = null;
        });
        _startNext();
      });
    });
  }

  // ── Helpers de posição ───────────────────────────────────────────────────

  /// Delega para a função pública de mesmo nome.
  static Offset _gridCenter(int index, Size screen) =>
      morphGridCenter(index, screen);

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _screenSize = constraints.biggest;
        final screen = _screenSize;
        final center = Offset(screen.width / 2, screen.height / 2);
        final szSphere = sphereSize(screen.width);
        final orbitR = orbitRadius(screen.width);

        return AnimatedBuilder(
          animation: Listenable.merge([_orbitController, _travelController]),
          builder: (context, _) {
            final t = _travelController.value; // 0→1

            // Índice da esfera/card em voo (se houver).
            final animatingIdx =
                widget.reversing ? _completedCount - 1 : _completedCount;

            // Quais índices estão como cards completamente colocados.
            final placedMax =
                widget.reversing ? _completedCount : _completedCount;

            return Stack(
              children: [
                // ── 1. Esferas ainda em órbita ──────────────────────────
                ..._buildOrbitingSpheres(
                  animatingIdx: _isAnimating ? animatingIdx : -1,
                  center: center,
                  orbitR: orbitR,
                  szSphere: szSphere,
                ),

                // ── 2. Esfera/card em voo+morfismo ──────────────────────
                if (_isAnimating && _travelStart != null)
                  _buildTraveling(
                    index: animatingIdx,
                    t: t,
                    center: center,
                    screen: screen,
                    szSphere: szSphere,
                  ),

                // ── 3. Cards já colocados ────────────────────────────────
                for (int i = 0; i < placedMax; i++)
                  if (!(_isAnimating && i == animatingIdx))
                    _buildPlacedCard(i, screen),
              ],
            );
          },
        );
      },
    );
  }

  // ── Sub-builders ─────────────────────────────────────────────────────────

  List<Widget> _buildOrbitingSpheres({
    required int animatingIdx,
    required Offset center,
    required double orbitR,
    required double szSphere,
  }) {
    final baseAngle = _orbitController.value * 2 * pi;
    final widgets = <Widget>[];

    for (int i = 0; i < kSkills.length; i++) {
      final isPlaced = widget.reversing ? i >= _completedCount : i < _completedCount;
      final isAnimating = i == animatingIdx && _isAnimating;
      if (isPlaced || isAnimating) continue;

      final angle = baseAngle + (i / kSkills.length) * 2 * pi;
      final dx = cos(angle) * orbitR;
      final dy = sin(angle) * orbitR;
      final pos = Offset(center.dx + dx - szSphere / 2,
          center.dy + dy - szSphere / 2);

      widgets.add(
        Positioned(
          left: pos.dx,
          top: pos.dy,
          child: AnimatedSphere(
            key: ValueKey('orbit_$i'),
            color: kSkills[i].color,
            size: szSphere,
            pulsing: true,
          ),
        ),
      );
    }
    return widgets;
  }

  Widget _buildTraveling({
    required int index,
    required double t,
    required Offset center,
    required Size screen,
    required double szSphere,
  }) {
    final skill = kSkills[index];

    // Fases do controller (0→1):
    // 0.0 → travelFrac: voo (posição muda)
    // travelFrac → 1.0 : morfismo na posição final
    const travelFrac = _kTravelMs / _kTotalMs; // ≈ 0.636

    // Posição
    final travelT = (t / travelFrac).clamp(0.0, 1.0);
    final curvedTravel = Curves.easeInOutCubic.transform(travelT);

    final Offset startAbs = center + _travelStart!;
    final Offset endAbs = widget.reversing
        ? center // morph-in: volta para o centro da tela
        : _gridCenter(index, screen);

    final currentPos = Offset.lerp(startAbs, endAbs, curvedTravel)!;

    // Morfismo (começa quando o voo termina)
    final morphT =
        ((t - travelFrac) / (1.0 - travelFrac)).clamp(0.0, 1.0);
    final curvedMorph = Curves.easeOutBack.transform(morphT);

    final double w = lerpDouble(szSphere, _kCardW, curvedMorph)!;
    final double h = lerpDouble(szSphere, _kCardH, curvedMorph)!;
    final double radius = lerpDouble(szSphere / 2, _kCardRadius, curvedMorph)!;
    final double contentOpacity =
        ((morphT - 0.65) / 0.35).clamp(0.0, 1.0);

    // No modo reverso, invertemos o morfismo visualmente
    final double wR = widget.reversing ? lerpDouble(_kCardW, szSphere, curvedMorph)! : w;
    final double hR = widget.reversing ? lerpDouble(_kCardH, szSphere, curvedMorph)! : h;
    final double radiusR =
        widget.reversing ? lerpDouble(_kCardRadius, szSphere / 2, curvedMorph)! : radius;
    final double contentOpR =
        widget.reversing ? (1.0 - contentOpacity).clamp(0.0, 1.0) : contentOpacity;

    return Positioned(
      left: currentPos.dx - wR / 2,
      top: currentPos.dy - hR / 2,
      child: _MorphingTile(
        skill: skill,
        width: wR,
        height: hR,
        borderRadius: radiusR,
        contentOpacity: contentOpR,
        sphereSize: szSphere,
        morphT: widget.reversing ? 1.0 - curvedMorph : curvedMorph,
      ),
    );
  }

  Widget _buildPlacedCard(int index, Size screen) {
    final center = _gridCenter(index, screen);
    return Positioned(
      left: center.dx - _kCardW / 2,
      top: center.dy - _kCardH / 2,
      child: _PlacedCard(skill: kSkills[index]),
    );
  }
}

// ── Tile em morfismo (esfera → card ou card → esfera) ────────────────────────
class _MorphingTile extends StatelessWidget {
  final Skill skill;
  final double width;
  final double height;
  final double borderRadius;
  final double contentOpacity;
  final double sphereSize;
  final double morphT; // 0 = esfera pura, 1 = card completo

  const _MorphingTile({
    required this.skill,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.contentOpacity,
    required this.sphereSize,
    required this.morphT,
  });

  @override
  Widget build(BuildContext context) {
    // Enquanto morphT < 0.05: renderiza a esfera com CustomPaint puro.
    if (morphT < 0.05) {
      return SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _SpherePainter(color: skill.color, glowIntensity: 0.6),
        ),
      );
    }

    // Gradiente que transita de radial (esfera) para linear (card).
    final gradient = morphT < 0.5
        ? RadialGradient(
            center: const Alignment(-0.3, -0.35),
            radius: 0.85,
            colors: [
              Color.lerp(Colors.white, skill.color, 0.3)!,
              skill.color,
              HSLColor.fromColor(skill.color)
                  .withLightness(
                    (HSLColor.fromColor(skill.color).lightness * 0.4)
                        .clamp(0.0, 1.0),
                  )
                  .toColor(),
            ],
            stops: const [0.0, 0.5, 1.0],
          ) as Gradient
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              skill.color.withValues(alpha: 0.22),
              skill.color.withValues(alpha: 0.08),
            ],
          );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
        border: Border.all(
          color: skill.color.withValues(alpha: 0.4 * morphT),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: skill.color.withValues(alpha: 0.3 + morphT * 0.1),
            blurRadius: 8 + morphT * 16,
            spreadRadius: morphT * 3,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Opacity(
        opacity: contentOpacity,
        child: _CardBody(skill: skill),
      ),
    );
  }
}

// ── Card colocado definitivamente no grid ─────────────────────────────────────
class _PlacedCard extends StatefulWidget {
  final Skill skill;
  const _PlacedCard({required this.skill});

  @override
  State<_PlacedCard> createState() => _PlacedCardState();
}

class _PlacedCardState extends State<_PlacedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatCtrl;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (context, child) {
        final dy = _floatCtrl.value * 6 - 3;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: _HoverableCard(skill: widget.skill, hovered: _hovered),
        ),
      ),
    );
  }
}

class _HoverableCard extends StatelessWidget {
  final Skill skill;
  final bool hovered;
  const _HoverableCard({required this.skill, required this.hovered});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_kCardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _kCardW,
          height: _kCardH,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_kCardRadius),
            color: skill.color.withValues(alpha: hovered ? 0.22 : 0.13),
            border: Border.all(
              color: skill.color.withValues(alpha: hovered ? 0.7 : 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: skill.color.withValues(alpha: hovered ? 0.35 : 0.15),
                blurRadius: hovered ? 24 : 12,
                spreadRadius: hovered ? 4 : 2,
              ),
            ],
          ),
          child: _CardBody(skill: skill),
        ),
      ),
    );
  }
}

// ── Conteúdo do card ─────────────────────────────────────────────────────────
class _CardBody extends StatelessWidget {
  final Skill skill;
  const _CardBody({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: skill.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: skill.color.withValues(alpha: 0.5)),
            ),
            child: Icon(skill.icon, color: skill.color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            skill.title,
            style: GoogleFonts.inter(
              color: skill.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              skill.impact,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: skill.domains.take(2).map((d) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: skill.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  d,
                  style: GoogleFonts.inter(
                    color: skill.color.withValues(alpha: 0.9),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Painter reutilizado para esfera em voo ────────────────────────────────────
class _SpherePainter extends CustomPainter {
  final Color color;
  final double glowIntensity;

  const _SpherePainter({required this.color, required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Glow
    canvas.drawCircle(
      center,
      radius * 0.9,
      Paint()
        ..maskFilter =
            MaskFilter.blur(BlurStyle.normal, 8 + glowIntensity * 8)
        ..color = color.withValues(alpha: 0.3 + glowIntensity * 0.3),
    );

    // Corpo com gradiente 3D
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.35, -0.4),
          radius: 0.8,
          colors: [
            Color.lerp(Colors.white, color, 0.3)!,
            color,
            color.withValues(alpha: 0.7),
            HSLColor.fromColor(color)
                .withLightness(
                  (HSLColor.fromColor(color).lightness * 0.4).clamp(0.0, 1.0),
                )
                .toColor(),
          ],
          stops: const [0.0, 0.4, 0.75, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    // Highlight
    canvas.drawCircle(
      Offset(center.dx - radius * 0.28, center.dy - radius * 0.28),
      radius * 0.45,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.45),
          radius: 0.5,
          colors: [
            Colors.white.withValues(alpha: 0.7),
            Colors.white.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(_SpherePainter old) =>
      old.glowIntensity != glowIntensity || old.color != color;
}
