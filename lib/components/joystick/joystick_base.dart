import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class JoystickBase extends StatelessWidget {
  final JoystickMode mode;
  final double size;

  const JoystickBase({
    Key? key,
    this.mode = JoystickMode.all,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _JoystickBasePainter(context, mode, size),
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  _JoystickBasePainter(this.context, this.mode, this.size);

  final BuildContext context;
  final JoystickMode mode;
  final double size;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = Theme.of(context).colorScheme.primaryContainer
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    final centerPaint = Paint()
      ..color = Theme.of(context).colorScheme.primaryContainer
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final multiplier = this.size / 200;
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, borderPaint);
    canvas.drawCircle(center, radius - 12, centerPaint);
    canvas.drawCircle(center, radius - 60, centerPaint);

    if (mode != JoystickMode.horizontal) {
      // draw vertical arrows
      canvas.drawLine(
          Offset(center.dx - 30 * multiplier, center.dy - 50 * multiplier),
          Offset(center.dx + 1, center.dy - 70 * multiplier),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + 30 * multiplier, center.dy - 50 * multiplier),
          Offset(center.dx - 1, center.dy - 70 * multiplier),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - 30 * multiplier, center.dy + 50 * multiplier),
          Offset(center.dx + 1, center.dy + 70 * multiplier),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + 30 * multiplier, center.dy + 50 * multiplier),
          Offset(center.dx - 1, center.dy + 70 * multiplier),
          linePaint);
    }

    if (mode != JoystickMode.vertical) {
      // draw horizontal arrows
      canvas.drawLine(
          Offset(center.dx - 50 * multiplier, center.dy - 30 * multiplier),
          Offset(center.dx - 70 * multiplier, center.dy + 1),
          linePaint);
      canvas.drawLine(
          Offset(center.dx - 50 * multiplier, center.dy + 30 * multiplier),
          Offset(center.dx - 70 * multiplier, center.dy - 1),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + 50 * multiplier, center.dy - 30 * multiplier),
          Offset(center.dx + 70 * multiplier, center.dy + 1),
          linePaint);
      canvas.drawLine(
          Offset(center.dx + 50 * multiplier, center.dy + 30 * multiplier),
          Offset(center.dx + 70 * multiplier, center.dy - 1),
          linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
