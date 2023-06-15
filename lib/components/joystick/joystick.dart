import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart' as joystick;

import 'joystick_base.dart';
import 'joystick_stick.dart';

class Joystick extends StatelessWidget {
  final void Function(joystick.StickDragDetails) listener;

  const Joystick({Key? key, required this.listener}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return joystick.Joystick(
      listener: listener,
      base: const JoystickBase(),
      stick: const JoystickStick(),
      period: const Duration(milliseconds: 5),
    );
  }
}
