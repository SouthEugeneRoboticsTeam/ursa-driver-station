import 'package:flutter/material.dart';

extension ColorSchemeExtension on ColorScheme {
  Color get green => brightness == Brightness.light
      ? Colors.green.shade300
      : Colors.green.shade100;
  Color get greenContainer => brightness == Brightness.light
      ? Colors.green.shade100
      : Colors.green.shade300;

  Color get yellow => brightness == Brightness.light
      ? Colors.orange.shade300
      : Colors.orange.shade100;
  Color get yellowContainer => brightness == Brightness.light
      ? Colors.orange.shade100
      : Colors.orange.shade300;

  Color get red => brightness == Brightness.light
      ? Colors.red.shade300
      : Colors.red.shade100;
  Color get redContainer => brightness == Brightness.light
      ? Colors.red.shade100
      : Colors.red.shade300;
}
