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
        painter: _JoystickBasePainter(mode, size),
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  _JoystickBasePainter(this.mode, this.size);

  final JoystickMode mode;
  final double size;

  final _borderPaint = Paint()
    // ..color = const Color(0x50616161)
    ..color = Colors.grey.shade300
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;
  final _centerPaint = Paint()
    // ..color = const Color(0x50616161)
    ..color = Colors.grey.shade300
    ..style = PaintingStyle.fill;
  final _linePaint = Paint()
    // ..color = const Color(0x50616161)
    ..color = Colors.grey.shade500
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final multiplier = this.size / 200;
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, _borderPaint);
    canvas.drawCircle(center, radius - 12, _centerPaint);
    canvas.drawCircle(center, radius - 60, _centerPaint);

    if (mode != JoystickMode.horizontal) {
      // draw vertical arrows
      canvas.drawLine(Offset(center.dx - 30 * multiplier, center.dy - 50 * multiplier),
          Offset(center.dx + 1, center.dy - 70 * multiplier), _linePaint);
      canvas.drawLine(Offset(center.dx + 30 * multiplier, center.dy - 50 * multiplier),
          Offset(center.dx - 1, center.dy - 70 * multiplier), _linePaint);
      canvas.drawLine(Offset(center.dx - 30 * multiplier, center.dy + 50 * multiplier),
          Offset(center.dx + 1, center.dy + 70 * multiplier), _linePaint);
      canvas.drawLine(Offset(center.dx + 30 * multiplier, center.dy + 50 * multiplier),
          Offset(center.dx - 1, center.dy + 70 * multiplier), _linePaint);
    }

    if (mode != JoystickMode.vertical) {
      // draw horizontal arrows
      canvas.drawLine(Offset(center.dx - 50 * multiplier, center.dy - 30 * multiplier),
          Offset(center.dx - 70 * multiplier, center.dy + 1), _linePaint);
      canvas.drawLine(Offset(center.dx - 50 * multiplier, center.dy + 30 * multiplier),
          Offset(center.dx - 70 * multiplier, center.dy - 1), _linePaint);
      canvas.drawLine(Offset(center.dx + 50 * multiplier, center.dy - 30 * multiplier),
          Offset(center.dx + 70 * multiplier, center.dy + 1), _linePaint);
      canvas.drawLine(Offset(center.dx + 50 * multiplier, center.dy + 30 * multiplier),
          Offset(center.dx + 70 * multiplier, center.dy - 1), _linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
