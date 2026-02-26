import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/skill_model.dart';

class SkillCard extends StatefulWidget {
  final Skill skill;
  final bool visible;
  final int index;

  const SkillCard({
    super.key,
    required this.skill,
    this.visible = true,
    this.index = 0,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.skill.color;

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset = _floatController.value * 8 - 4; // -4 a +4 px
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: child,
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: _CardContent(
            skill: widget.skill,
            color: color,
            hovered: _hovered,
          )
              .animate(delay: Duration(milliseconds: widget.index * 100))
              .fadeIn(duration: const Duration(milliseconds: 500))
              .slideY(begin: 0.2, end: 0),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final Skill skill;
  final Color color;
  final bool hovered;

  const _CardContent({
    required this.skill,
    required this.color,
    required this.hovered,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 160,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withValues(alpha: hovered ? 0.22 : 0.13),
            border: Border.all(
              color: color.withValues(alpha: hovered ? 0.7 : 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: hovered ? 0.35 : 0.15),
                blurRadius: hovered ? 24 : 12,
                spreadRadius: hovered ? 4 : 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ícone + cor de destaque
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Icon(skill.icon, color: color, size: 20),
              ),
              const SizedBox(height: 10),
              // Título
              Text(
                skill.title,
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              // Frase de impacto
              Text(
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
              const Spacer(),
              // Domínios como chips
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: skill.domains.take(2).map((d) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      d,
                      style: GoogleFonts.inter(
                        color: color.withValues(alpha: 0.9),
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
