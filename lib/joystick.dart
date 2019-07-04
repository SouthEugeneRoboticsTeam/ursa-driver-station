import 'package:flutter/material.dart';
import 'dart:math' as math;

class Joystick extends StatefulWidget {
  final void Function(int x, int y) onPositionChange;

  Joystick({this.onPositionChange});

  @override
  JoystickState createState() => JoystickState();
}

class JoystickState extends State<Joystick> with TickerProviderStateMixin {
  static const tipSize = 75.0;
  static const baseSize = tipSize * 2;
  static const maxAxisValue = 100.0;
  static const maxScaledAxisValue = maxAxisValue * .75;

  Offset origin = Offset.zero;
  Offset currentOffset = Offset.zero;

  Animation<double> opacityAnimation;
  Animation<double> sizeAnimation;
  Animation<Color> distanceColorAnimation;
  AnimationController animationController;
  AnimationController distanceAnimationController;

  Offset get position {
    return calculatePosition(currentOffset, origin) *
        maxAxisValue /
        maxScaledAxisValue;
  }

  Offset calculateMaxPosition(offset) {
    var nextPosition = calculatePosition(offset, origin);
    var angle = math.atan(
        nextPosition.dy == 0.0 ? 0.0 : nextPosition.dy / nextPosition.dx);
    return Offset(
      (math.cos(angle) * maxScaledAxisValue).abs(),
      (math.sin(angle) * maxScaledAxisValue).abs(),
    );
  }

  Offset constrainOffset(Offset offset) {
    var maxPosition = calculateMaxPosition(offset);
    return Offset(
      constrain(offset.dx, origin.dx, maxPosition.dx),
      constrain(offset.dy, origin.dy, maxPosition.dy),
    );
  }

  @override
  initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);

    opacityAnimation =
    CurvedAnimation(parent: animationController, curve: Curves.easeOut)
      ..addListener(() => setState(() => {}));
    sizeAnimation =
    CurvedAnimation(parent: animationController, curve: Curves.elasticOut)
      ..addListener(() => setState(() => {}));

    distanceAnimationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    final Tween colorTween =
    ColorTween(begin: Colors.grey[300], end: Colors.red[400]);
    distanceColorAnimation = colorTween.animate(distanceAnimationController)
      ..addListener(() => setState(() => {}));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Offset globalToLocalOffset(details) {
    RenderBox getBox = context.findRenderObject();
    return getBox.globalToLocal(details.globalPosition);
  }

  int adjustForSensibility(double val) =>
      val.abs() < 5 ? 0 : val.round();

  void changePosition(setStateFn) {
    int previousX = adjustForSensibility(position.dx);
    int previousY = adjustForSensibility(position.dy);
    setState(setStateFn);
    int newX = adjustForSensibility(position.dx);
    int newY = adjustForSensibility(position.dy);
    // Notify only on integer changes to reduce the number of messages sent
    if (newX != previousX || newY != previousY)
      widget.onPositionChange(newX, newY);
  }

  void onPanDown(details) {
    changePosition(() => origin = currentOffset = globalToLocalOffset(details));
    animationController.reset();
    animationController.forward();
  }

  void onPanUpdate(details) {
    changePosition(() {
      currentOffset = constrainOffset(globalToLocalOffset(details));
    });
  }

  void onPanEnd(details) {
    changePosition(() => currentOffset = origin);
    animationController.reverse();
  }

  Widget buildJoystickBase() {
    var animatedSize = baseSize * sizeAnimation.value;
    return Positioned(
      top: origin.dy - animatedSize / 2,
      left: origin.dx - animatedSize / 2,
      child: Container(
        height: animatedSize,
        width: animatedSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(opacityAnimation.value * 0.3),
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
      ),
    );
  }

  Widget buildJoystickTip() {
    return Positioned(
      top: currentOffset.dy - tipSize / 2,
      left: currentOffset.dx - tipSize / 2,
      child: Container(
        height: tipSize,
        width: tipSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(opacityAnimation.value * 0.7),
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
      ),
    );
  }

  Widget buildHint() {
    return Align(
      alignment: Alignment(0, 0.2),
      child: Text(
        'tap and hold\nthen drag',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30.0,
          color: Colors.black.withOpacity(0.3 * (1 - opacityAnimation.value)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Container(
            color: distanceColorAnimation.value,
            child: buildHint(),
          ),
          buildJoystickBase(),
          buildJoystickTip(),
          GestureDetector(
            onPanDown: onPanDown,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
          )
        ],
      ),
    );
  }
}

double constrain(double currentValue, double previousValue, double maxValue) {
  return currentValue > previousValue && currentValue - previousValue > maxValue
      ? previousValue + maxValue
      : currentValue < previousValue && previousValue - currentValue > maxValue
      ? previousValue - maxValue
      : currentValue;
}

Offset calculatePosition(Offset offset, Offset origin) {
  return Offset(
    offset.dx - origin.dx,
    origin.dy - offset.dy,
  );
}