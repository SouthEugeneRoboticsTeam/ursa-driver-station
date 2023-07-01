import 'package:flutter/material.dart';

class JoystickStick extends StatelessWidget {
  final double size;

  const JoystickStick({Key? key, this.size = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
