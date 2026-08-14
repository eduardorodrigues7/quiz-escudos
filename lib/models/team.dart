import 'package:flutter/material.dart';

/// Padroes de pintura do escudo, inspirados nos uniformes classicos.
enum ShieldPattern {
  solid,
  halves,
  verticalStripes,
  horizontalStripes,
  tricolorVertical,
  tricolorHorizontal,
  sash,
  cross,
}

@immutable
class Team {
  final String name;
  final String state;
  final String nickname;
  final Color primary;
  final Color secondary;
  final Color detail;
  final ShieldPattern pattern;

  const Team({
    required this.name,
    required this.state,
    required this.nickname,
    required this.primary,
    required this.secondary,
    required this.detail,
    required this.pattern,
  });

  @override
  bool operator ==(Object other) => other is Team && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
