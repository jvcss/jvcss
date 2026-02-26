import 'package:flutter/material.dart';

class Skill {
  final String id;
  final String title;
  final String impact;
  final List<String> domains;
  final Color color;
  final IconData icon;

  const Skill({
    required this.id,
    required this.title,
    required this.impact,
    required this.domains,
    required this.color,
    required this.icon,
  });
}
