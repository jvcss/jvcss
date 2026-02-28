import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/ai_judgement_model.dart';

class AiJudgementCard extends StatefulWidget {
  final AiJudgement judgement;

  const AiJudgementCard({super.key, required this.judgement});

  @override
  State<AiJudgementCard> createState() => _AiJudgementCardState();
}

class _AiJudgementCardState extends State<AiJudgementCard>
    with SingleTickerProviderStateMixin {
  // Ticker gives monotonically increasing elapsed time.
  // Unlike AnimationController.repeat(), the value NEVER jumps from ~1.0 to 0.0
  // in a single frame – it always advances by ~16ms. Any (t * speed) % 1.0
  // therefore wraps by at most speed * 0.016/6 ≈ 0.002 per frame: invisible.
  late Ticker _ticker;
  double _t = 0; // seconds elapsed, grows forever

  String _displayedText = '';
  Timer? _typewriterTimer;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() => _t = elapsed.inMicroseconds / 1000000.0);
    });
    _ticker.start();

    if (!widget.judgement.isLoading && widget.judgement.text.isNotEmpty) {
      _startTypewriter(widget.judgement.text);
    }
  }

  @override
  void didUpdateWidget(AiJudgementCard old) {
    super.didUpdateWidget(old);
    if (!widget.judgement.isLoading &&
        widget.judgement.text.isNotEmpty &&
        widget.judgement.text != old.judgement.text) {
      _startTypewriter(widget.judgement.text);
    }
  }

  void _startTypewriter(String fullText) {
    _typewriterTimer?.cancel();
    _displayedText = '';
    int index = 0;
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 18), (t) {
      if (index >= fullText.length) {
        t.cancel();
        return;
      }
      setState(() => _displayedText = fullText.substring(0, ++index));
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Julgamento do Perfil Por I.A',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
          const SizedBox(height: 6),
          Text(
            'Análise dos commits usando Claude Haiku',
            style: GoogleFonts.inter(
              color: const Color(0xFF7986CB),
              fontSize: 13,
            ),
          ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
          const SizedBox(height: 24),
          CustomPaint(
            painter: _AuroraBackgroundPainter(t: _t),
            foregroundPainter: _AuroraBorderPainter(t: _t),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(24),
                  color: Colors.white.withValues(alpha: 0.03),
                  child: widget.judgement.isLoading
                      ? _LoadingContent()
                      : widget.judgement.error != null
                          ? _ErrorContent(error: widget.judgement.error!)
                          : _TextContent(text: _displayedText),
                ),
              ),
            ),
          )
              .animate(delay: const Duration(milliseconds: 300))
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.15, end: 0),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Background: four aurora blobs drifting with sin/cos.
// sin/cos are naturally periodic – no seam exists anywhere in their range.
// ─────────────────────────────────────────────────────────────────────────────
class _AuroraBackgroundPainter extends CustomPainter {
  final double t; // seconds elapsed (monotonically increasing)

  const _AuroraBackgroundPainter({required this.t});

  // Cycle duration: 6 s → angular frequency = 2π/6
  static const _w = math.pi / 3; // = 2π/6

  // M300 palette – noticeably vivid over dark, still readable against white text
  static const _purple = Color(0xFFBA68C8); // purple  M300
  static const _blue   = Color(0xFF42A5F5); // blue    M300
  static const _cyan   = Color(0xFF26C6DA); // cyan    M300
  static const _dark   = Color(0xFF07071A);

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawPaint(Paint()..color = _dark);

    // Each blob's position = A + B*sin/cos(ω*t + φ).
    // With monotonic t, there is no modulo jump → perfectly seamless.
    _blob(canvas, size, _purple,
        cx: 0.12 + 0.22 * math.sin(_w * t),
        cy: 0.25 + 0.15 * math.cos(_w * t * 0.71),
        r: size.width * 0.58,
        a: 0.36);
    _blob(canvas, size, _blue,
        cx: 0.80 + 0.18 * math.sin(_w * t * 0.83 + 2.09),
        cy: 0.65 + 0.20 * math.cos(_w * t * 0.67 + 1.05),
        r: size.width * 0.52,
        a: 0.30);
    _blob(canvas, size, _cyan,
        cx: 0.50 + 0.25 * math.cos(_w * t * 0.59 + 4.19),
        cy: 0.80 + 0.12 * math.sin(_w * t * 0.91 + 0.73),
        r: size.width * 0.44,
        a: 0.26);
    _blob(canvas, size, _purple,
        cx: 0.88 + 0.08 * math.cos(_w * t * 0.47 + 1.80),
        cy: 0.10 + 0.18 * math.sin(_w * t * 0.79 + 3.14),
        r: size.width * 0.34,
        a: 0.20);

    canvas.restore();
  }

  void _blob(
    Canvas canvas,
    Size size,
    Color color, {
    required double cx,
    required double cy,
    required double r,
    required double a,
  }) {
    final center = Offset(cx * size.width, cy * size.height);
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: a),
            color.withValues(alpha: a * 0.35),
            color.withValues(alpha: 0),
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
  }

  @override
  bool shouldRepaint(_AuroraBackgroundPainter old) => old.t != t;
}

// ─────────────────────────────────────────────────────────────────────────────
// Border: three vivid glows orbiting via PathMetrics.
//
// fraction = (t / period * speed + phase) % 1.0
// Because t advances by only ~0.016 s per frame, the fraction changes by at
// most speed * 0.016/6 ≈ 0.002 – the same tiny step as any other frame.
// The modulo wrap is therefore invisible, even for speed ≠ 1.0.
// ─────────────────────────────────────────────────────────────────────────────
class _AuroraBorderPainter extends CustomPainter {
  final double t;

  const _AuroraBorderPainter({required this.t});

  static const _period = 6.0; // seconds per full orbit at speed = 1.0

  // Accent palette – electric but not neon; bright enough to pop on dark bg
  static const _purple = Color(0xFFCE93D8); // purple  M200  (glow rim)
  static const _blue   = Color(0xFF64B5F6); // blue    M200
  static const _cyan   = Color(0xFF80DEEA); // cyan    M200

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );

    // Subtle base stroke for definition
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = Colors.white.withValues(alpha: 0.10),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final totalLength = metrics.first.length;

    final lights = <({
      Color color,
      double speed,
      double phase,
      double sigma,
      double alpha,
    })>[
      (color: _purple, speed: 1.00, phase: 0.00, sigma: 22.0, alpha: 0.90),
      (color: _blue,   speed: 0.73, phase: 0.37, sigma: 17.0, alpha: 0.80),
      (color: _cyan,   speed: 0.61, phase: 0.63, sigma: 14.0, alpha: 0.70),
    ];

    for (final light in lights) {
      // t grows by ~0.016 s/frame → fraction changes by speed*0.016/6 ≈ 0.002.
      // The % 1.0 wrap is as invisible as any other frame-to-frame step.
      final fraction = (t / _period * light.speed + light.phase) % 1.0;
      final tangent =
          metrics.first.getTangentForOffset(fraction * totalLength);
      if (tangent == null) continue;

      canvas.drawCircle(
        tangent.position,
        4,
        Paint()
          ..color = light.color.withValues(alpha: light.alpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, light.sigma),
      );
    }
  }

  @override
  bool shouldRepaint(_AuroraBorderPainter old) => old.t != t;
}

// ─────────────────────────────────────────────────────────────────────────────
// Content widgets
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const CircularProgressIndicator(
          color: Color(0xFFBA68C8),
          strokeWidth: 2,
        ),
        const SizedBox(height: 16),
        Text(
          'Claude está analisando seus commits...',
          style: GoogleFonts.inter(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String error;
  const _ErrorContent({required this.error});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error_outline, color: Color(0xFFEF5350)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Erro ao carregar análise: $error',
            style: GoogleFonts.inter(
              color: const Color(0xFFEF5350),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

class _TextContent extends StatelessWidget {
  final String text;
  const _TextContent({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 14,
        height: 1.7,
      ),
    );
  }
}
