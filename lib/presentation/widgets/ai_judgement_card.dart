import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
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
  late AnimationController _borderController;
  String _displayedText = '';
  Timer? _typewriterTimer;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

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
    _borderController.dispose();
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
          // Título
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
          // Card principal
          AnimatedBuilder(
            animation: _borderController,
            builder: (context, child) {
              return _GradientBorderCard(
                progress: _borderController.value,
                child: child!,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 600),
                  padding: const EdgeInsets.all(24),
                  color: const Color(0xFFAB47BC).withValues(alpha: 0.08),
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

class _GradientBorderCard extends StatelessWidget {
  final double progress;
  final Widget child;

  const _GradientBorderCard({required this.progress, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: SweepGradient(
          startAngle: progress * 6.28,
          endAngle: progress * 6.28 + 6.28,
          colors: const [
            Color(0xFFAB47BC),
            Color(0xFF42A5F5),
            Color(0xFF26C6DA),
            Color(0xFFAB47BC),
          ],
        ),
      ),
      padding: const EdgeInsets.all(1.5),
      child: child,
    );
  }
}

class _LoadingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const CircularProgressIndicator(
          color: Color(0xFFAB47BC),
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
