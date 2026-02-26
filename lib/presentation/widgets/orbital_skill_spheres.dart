import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/skills_data.dart';
import '../../data/models/skill_model.dart';
import 'animated_sphere.dart';

class OrbitalSkillSpheres extends StatefulWidget {
  final double containerSize;
  final double orbitRadius;
  final double sphereSize;

  const OrbitalSkillSpheres({
    super.key,
    this.containerSize = 320,
    this.orbitRadius = 110,
    this.sphereSize = 30,
  });

  @override
  State<OrbitalSkillSpheres> createState() => _OrbitalSkillSpheresState();
}

class _OrbitalSkillSpheresState extends State<OrbitalSkillSpheres>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotController;
  int? _hoveredIndex;
  double? _frozenValue;

  @override
  void initState() {
    super.initState();
    _rotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _rotController.dispose();
    super.dispose();
  }

  double _angleForIndex(int i, double controllerValue) {
    return controllerValue * 360.0 + (i / kSkills.length) * 360.0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotController,
      builder: (context, _) {
        final currentValue = _rotController.value;

        // Render hovered sphere last so it appears on top
        final indices = List.generate(kSkills.length, (i) => i);
        if (_hoveredIndex != null) {
          indices
            ..remove(_hoveredIndex!)
            ..add(_hoveredIndex!);
        }

        return SizedBox(
          width: widget.containerSize,
          height: widget.containerSize,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _ProfilePhoto(),
              ...indices.map((i) {
                final effectiveValue =
                    (_hoveredIndex == i && _frozenValue != null)
                        ? _frozenValue!
                        : currentValue;
                final angle = _angleForIndex(i, effectiveValue);
                final offset = orbitalOffset(angle, widget.orbitRadius);

                return Transform.translate(
                  offset: offset,
                  child: FractionalTranslation(
                    translation: const Offset(-0.5, -0.5),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) {
                        _frozenValue = currentValue;
                        setState(() => _hoveredIndex = i);
                      },
                      onExit: (_) => setState(() {
                        _hoveredIndex = null;
                        _frozenValue = null;
                      }),
                      child: _SphereOrCard(
                        isHovered: _hoveredIndex == i,
                        skill: kSkills[i],
                        sphereSize: widget.sphereSize,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

// ── Profile photo frame ────────────────────────────────────────────────────────
class _ProfilePhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
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
            color: const Color(0xFFAB47BC).withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 6,
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
          child: Container(
            color: const Color(0xFF131836),
            child: const Icon(
              Icons.person,
              size: 70,
              color: Color(0xFF7986CB),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Sphere ↔ Card morph ────────────────────────────────────────────────────────
class _SphereOrCard extends StatelessWidget {
  final bool isHovered;
  final Skill skill;
  final double sphereSize;

  const _SphereOrCard({
    required this.isHovered,
    required this.skill,
    required this.sphereSize,
  });

  @override
  Widget build(BuildContext context) {
    const cardW = 165.0;
    const cardH = 145.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutBack,
      width: isHovered ? cardW : sphereSize,
      height: isHovered ? cardH : sphereSize,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isHovered ? 12 : sphereSize / 2),
        gradient: isHovered
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  skill.color.withValues(alpha: 0.18),
                  skill.color.withValues(alpha: 0.08),
                ],
              )
            : RadialGradient(
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
              ),
        border: isHovered
            ? Border.all(
                color: skill.color.withValues(alpha: 0.4),
                width: 1,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: skill.color.withValues(alpha: isHovered ? 0.35 : 0.5),
            blurRadius: isHovered ? 24 : 8,
            spreadRadius: isHovered ? 2 : 0,
          ),
        ],
      ),
      child: AnimatedOpacity(
        opacity: isHovered ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 220),
        child: _CardContent(skill: skill),
      ),
    );
  }
}

// ── Card content shown on hover ────────────────────────────────────────────────
class _CardContent extends StatelessWidget {
  final Skill skill;

  const _CardContent({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Accent bar
        Container(height: 4, color: skill.color),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + title row
              Row(
                children: [
                  Icon(skill.icon, color: skill.color, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      skill.title,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Impact phrase
              Text(
                skill.impact,
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.72),
                  fontSize: 9.5,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Domain chips
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: skill.domains.take(2).map((d) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: skill.color.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      d,
                      style: GoogleFonts.inter(
                        color: skill.color,
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
