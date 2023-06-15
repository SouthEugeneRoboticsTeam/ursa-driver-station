import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart' as joystick;

import 'joystick_base.dart';
import 'joystick_stick.dart';

class Joystick extends StatelessWidget {
  final void Function(joystick.StickDragDetails) listener;

  final double size;

  const Joystick({Key? key, required this.listener, this.size = 200}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return joystick.Joystick(
      listener: listener,
      base: JoystickBase(size: size),
      stick: JoystickStick(size: size * 0.3),
      period: const Duration(milliseconds: 5),
    );
  }
}
