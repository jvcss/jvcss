import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedSphere extends StatefulWidget {
  final Color color;
  final double size;
  final bool pulsing;

  const AnimatedSphere({
    super.key,
    required this.color,
    this.size = 60,
    this.pulsing = true,
  });

  @override
  State<AnimatedSphere> createState() => _AnimatedSphereState();
}

class _AnimatedSphereState extends State<AnimatedSphere>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final glow = widget.pulsing ? _controller.value : 0.5;
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SpherePainter(color: widget.color, glowIntensity: glow),
        );
      },
    );
  }
}

class _SpherePainter extends CustomPainter {
  final Color color;
  final double glowIntensity;

  _SpherePainter({required this.color, required this.glowIntensity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Glow externo
    final glowPaint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + glowIntensity * 8)
      ..color = color.withValues(alpha: 0.3 + glowIntensity * 0.3);
    canvas.drawCircle(center, radius * 0.9, glowPaint);

    // Corpo da esfera com gradiente radial 3D
    final bodyPaint = Paint()
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
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bodyPaint);

    // Reflexo especular (highlight branco)
    final highlightPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.4, -0.45),
        radius: 0.5,
        colors: [
          Colors.white.withValues(alpha: 0.6 + glowIntensity * 0.2),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(
      Offset(center.dx - radius * 0.28, center.dy - radius * 0.28),
      radius * 0.45,
      highlightPaint,
    );

    // Borda fina brilhante
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = color.withValues(alpha: 0.5 + glowIntensity * 0.3);
    canvas.drawCircle(center, radius - 0.5, borderPaint);
  }

  @override
  bool shouldRepaint(_SpherePainter old) =>
      old.glowIntensity != glowIntensity || old.color != color;
}

// Versão estática da esfera (sem animação própria), para uso em animações externas
class StaticSphere extends StatelessWidget {
  final Color color;
  final double size;
  final double glowIntensity;

  const StaticSphere({
    super.key,
    required this.color,
    this.size = 60,
    this.glowIntensity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SpherePainter(color: color, glowIntensity: glowIntensity),
    );
  }
}

double lerp(double a, double b, double t) => a + (b - a) * t;

// Cria um offset orbital baseado no ângulo e raio
Offset orbitalOffset(double angleDeg, double radius) {
  final rad = angleDeg * pi / 180;
  return Offset(cos(rad) * radius, sin(rad) * radius);
}
