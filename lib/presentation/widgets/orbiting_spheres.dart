import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/breakpoints.dart';
import '../../data/models/skills_data.dart';
import 'animated_sphere.dart';

class OrbitingSpheres extends StatefulWidget {
  /// Se true, as esferas estão orbitando normalmente.
  /// Se false, dispara a animação de dispersão para os destinos.
  final bool scattering;
  final List<Offset> scatterTargets;
  final VoidCallback? onScatterComplete;

  const OrbitingSpheres({
    super.key,
    this.scattering = false,
    this.scatterTargets = const [],
    this.onScatterComplete,
  });

  @override
  State<OrbitingSpheres> createState() => _OrbitingSpheresState();
}

class _OrbitingSpheresState extends State<OrbitingSpheres>
    with SingleTickerProviderStateMixin {
  late AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = sphereSize(screenWidth);
    final radius = orbitRadius(screenWidth);

    return SizedBox(
      width: radius * 2 + size * 2,
      height: radius * 2 + size * 2,
      child: AnimatedBuilder(
        animation: _orbitController,
        builder: (context, _) {
          final baseAngle = _orbitController.value * 2 * pi;
          return Stack(
            alignment: Alignment.center,
            children: List.generate(kSkills.length, (i) {
              final angleOffset = (i / kSkills.length) * 2 * pi;
              final angle = baseAngle + angleOffset;
              final dx = cos(angle) * radius;
              final dy = sin(angle) * radius;

              return Transform.translate(
                offset: Offset(dx, dy),
                child: AnimatedSphere(
                  key: ValueKey(kSkills[i].id),
                  color: kSkills[i].color,
                  size: size,
                  pulsing: true,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

/// Widget que mostra uma única esfera voando do centro para um destino.
class ScatteringSphere extends StatelessWidget {
  final Color color;
  final double size;
  final Offset begin;
  final Offset end;
  final Duration delay;
  final Duration duration;

  const ScatteringSphere({
    super.key,
    required this.color,
    required this.size,
    required this.begin,
    required this.end,
    required this.delay,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: begin, end: end),
      duration: duration,
      curve: Curves.easeInOutCubic,
      builder: (context, offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: StaticSphere(color: color, size: size),
    )
        .animate(delay: delay)
        .fadeIn(duration: const Duration(milliseconds: 200));
  }
}
