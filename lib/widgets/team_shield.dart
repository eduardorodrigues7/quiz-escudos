import 'package:flutter/material.dart';

import '../models/team.dart';

/// Desenha o escudo do time no canvas, sem depender de imagens externas.
class TeamShield extends StatelessWidget {
  final Team team;
  final double size;

  const TeamShield({super.key, required this.team, this.size = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.12,
      child: CustomPaint(painter: _ShieldPainter(team)),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  final Team team;

  _ShieldPainter(this.team);

  Path _shieldPath(Size s) {
    final w = s.width;
    final h = s.height;
    return Path()
      ..moveTo(w * 0.08, h * 0.05)
      ..lineTo(w * 0.92, h * 0.05)
      ..lineTo(w * 0.92, h * 0.54)
      ..quadraticBezierTo(w * 0.92, h * 0.86, w * 0.5, h * 0.98)
      ..quadraticBezierTo(w * 0.08, h * 0.86, w * 0.08, h * 0.54)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _shieldPath(size);
    final full = Offset.zero & size;

    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(full, Paint()..color = team.primary);

    switch (team.pattern) {
      case ShieldPattern.solid:
        _paintSolid(canvas, size);
      case ShieldPattern.halves:
        _paintHalves(canvas, size);
      case ShieldPattern.verticalStripes:
        _paintBands(canvas, size, vertical: true, count: 7, colors: [team.primary, team.secondary]);
      case ShieldPattern.horizontalStripes:
        _paintBands(canvas, size, vertical: false, count: 7, colors: [team.primary, team.secondary]);
      case ShieldPattern.tricolorVertical:
        _paintBands(canvas, size, vertical: true, count: 6, colors: [team.primary, team.secondary, team.detail]);
      case ShieldPattern.tricolorHorizontal:
        _paintBands(canvas, size, vertical: false, count: 6, colors: [team.primary, team.secondary, team.detail]);
      case ShieldPattern.sash:
        _paintSash(canvas, size);
      case ShieldPattern.cross:
        _paintCross(canvas, size);
    }

    // Brilho suave, como a luz do refletor do estadio.
    canvas.drawRect(
      full,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x33FFFFFF), Color(0x00FFFFFF), Color(0x22000000)],
        ).createShader(full),
    );
    canvas.restore();

    // Contorno externo e filete interno.
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.05
        ..color = team.detail,
    );
    canvas.save();
    canvas.translate(size.width * 0.5, size.height * 0.5);
    canvas.scale(0.88);
    canvas.translate(-size.width * 0.5, -size.height * 0.5);
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.012
        ..color = team.detail.withOpacity(0.55),
    );
    canvas.restore();
  }

  void _paintSolid(Canvas canvas, Size s) {
    canvas.drawCircle(
      Offset(s.width * 0.5, s.height * 0.48),
      s.width * 0.22,
      Paint()..color = team.secondary,
    );
  }

  void _paintHalves(Canvas canvas, Size s) {
    canvas.drawRect(
      Rect.fromLTWH(s.width * 0.5, 0, s.width * 0.5, s.height),
      Paint()..color = team.secondary,
    );
  }

  void _paintBands(Canvas canvas, Size s, {required bool vertical, required int count, required List<Color> colors}) {
    final band = (vertical ? s.width : s.height) / count;
    for (var i = 0; i < count; i++) {
      final paint = Paint()..color = colors[i % colors.length];
      final rect = vertical
          ? Rect.fromLTWH(i * band, 0, band, s.height)
          : Rect.fromLTWH(0, i * band, s.width, band);
      canvas.drawRect(rect, paint);
    }
  }

  void _paintSash(Canvas canvas, Size s) {
    final sash = Path()
      ..moveTo(0, s.height * 0.78)
      ..lineTo(s.width * 0.72, 0)
      ..lineTo(s.width, 0)
      ..lineTo(s.width * 0.28, s.height)
      ..lineTo(0, s.height)
      ..close();
    canvas.drawPath(sash, Paint()..color = team.secondary);
  }

  void _paintCross(Canvas canvas, Size s) {
    final paint = Paint()..color = team.secondary;
    canvas.drawRect(Rect.fromLTWH(s.width * 0.42, 0, s.width * 0.16, s.height), paint);
    canvas.drawRect(Rect.fromLTWH(0, s.height * 0.40, s.width, s.height * 0.16), paint);
  }

  @override
  bool shouldRepaint(covariant _ShieldPainter oldDelegate) => oldDelegate.team != team;
}
