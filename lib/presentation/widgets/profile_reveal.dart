import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'animated_sphere.dart';

class ProfileReveal extends StatelessWidget {
  final bool nameVisible;
  final bool photoVisible;

  const ProfileReveal({
    super.key,
    this.nameVisible = false,
    this.photoVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (nameVisible) ...[
          Text(
            'João Victor Cardoso dos Santos',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.3, end: 0),
          const SizedBox(height: 4),
          Text(
            'JVCSS',
            style: GoogleFonts.inter(
              color: const Color(0xFFAB47BC),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 4,
            ),
          )
              .animate(delay: const Duration(milliseconds: 200))
              .fadeIn(duration: const Duration(milliseconds: 400)),
          const SizedBox(height: 24),
        ],
        // Moldura circular com foto (ou placeholder)
        _ProfileFrame(visible: photoVisible),
      ],
    );
  }
}

class _ProfileFrame extends StatelessWidget {
  final bool visible;

  const _ProfileFrame({required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const SweepGradient(
            colors: [
              Color(0xFFAB47BC),
              Color(0xFF42A5F5),
              Color(0xFF26C6DA),
              Color(0xFF66BB6A),
              Color(0xFFAB47BC),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFAB47BC).withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF0A0E27),
          ),
          child: ClipOval(
            child: _profileImage(),
          ),
        ),
      )
          .animate(delay: const Duration(milliseconds: 400))
          .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1))
          .fadeIn(duration: const Duration(milliseconds: 600)),
    );
  }

  Widget _profileImage() {
    // Placeholder: Avatar padrão até ter a foto real
    return Container(
      color: const Color(0xFF131836),
      child: const Icon(
        Icons.person,
        size: 80,
        color: Color(0xFF7986CB),
      ),
    );
  }
}

/// Exibe a esfera central se fundindo (animação de merge)
class MergingSphere extends StatelessWidget {
  const MergingSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSphere(color: const Color(0xFFAB47BC), size: 120)
        .animate()
        .scale(
          begin: const Offset(0.3, 0.3),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: const Duration(milliseconds: 400));
  }
}
