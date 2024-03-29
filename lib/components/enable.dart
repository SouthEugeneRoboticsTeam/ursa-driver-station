import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme.dart';
import 'animations/animated_text.dart';
import 'animations/colorize.dart';

class SlideToEnable extends StatefulWidget {
  final bool enabled;
  final Function(bool) onStateChange;

  final double? width;
  final double? height;

  const SlideToEnable({
    Key? key,
    required this.enabled,
    required this.onStateChange,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  SlideToEnableState createState() => SlideToEnableState();
}

class SlideToEnableState extends State<SlideToEnable>
    with SingleTickerProviderStateMixin {
  double _dragPercentage = 0;
  double _textOpacity = 1;

  bool _enabled = false;

  String _disableText = '';

  late Animation<double> dragAnimation;
  late AnimationController _dragController;

  late Animation<double> opacityAnimation;

  @override
  void didUpdateWidget(SlideToEnable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      _enabled = widget.enabled;
      if (widget.enabled) {
        _dragController.forward();
      } else {
        _dragController.reverse();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    dragAnimation = Tween<double>(begin: 0, end: 1).animate(_dragController)
      ..addListener(() {
        setState(() {
          _dragPercentage = dragAnimation.value;
        });
      });

    opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      _dragController
          .drive(CurveTween(curve: const Cubic(0.75, 0.25, 0.25, 1.0))),
    )..addListener(() {
        setState(() {
          _textOpacity = opacityAnimation.value;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    double height = widget.height ?? 70;

    Color boxColor = Theme.of(context).colorScheme.redContainer;
    Color ballColor = Theme.of(context).colorScheme.red;

    if (widget.enabled) {
      boxColor = Theme.of(context).colorScheme.greenContainer;
      ballColor = Theme.of(context).colorScheme.green;

      setState(() {
        _disableText = AppLocalizations.of(context)!.tapToDisable;
      });
    } else if (_enabled) {
      boxColor = Theme.of(context).colorScheme.yellowContainer;
      ballColor = Theme.of(context).colorScheme.yellow;

      setState(() {
        _disableText = AppLocalizations.of(context)!.enabling;
      });
    }

    return SizedBox(
      width: widget.width ?? min(MediaQuery.of(context).size.width * 0.85, 400),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth - height;

          return GestureDetector(
            onTap: () {
              if (_enabled) {
                setState(() {
                  _enabled = false;
                });

                _dragController.reverse();
                widget.onStateChange(_enabled);
              }
            },
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  height: height,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
                Opacity(
                  opacity: _textOpacity,
                  child: Container(
                    height: height,
                    padding: const EdgeInsets.only(right: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            AppLocalizations.of(context)!.slideToEnable,
                            speed: const Duration(milliseconds: 5000),
                            textAlign: TextAlign.center,
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: [
                              Colors.grey.shade600,
                              Colors.grey.shade600,
                              Colors.grey.shade700,
                              Colors.grey.shade800,
                              Colors.grey.shade900,
                              Colors.grey.shade800,
                              Colors.grey.shade700,
                              Colors.grey.shade600,
                              Colors.grey.shade600,
                            ],
                          )
                        ],
                        pause: const Duration(milliseconds: 0),
                        repeatForever: true,
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 1 - _textOpacity,
                  child: Container(
                    height: height,
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedOpacity(
                        opacity: _enabled || widget.enabled ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _disableText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _dragController,
                  builder: (context, child) {
                    return Positioned(
                      left: _dragPercentage * width,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _dragPercentage += details.delta.dx / width;
                            _dragPercentage = _dragPercentage.clamp(0.0, 1.0);
                            _dragController.value = _dragPercentage;
                          });
                        },
                        onPanEnd: (details) {
                          if (_dragPercentage < 0.6) {
                            setState(() {
                              _enabled = false;
                            });

                            _dragController.reverse();
                            widget.onStateChange(_enabled);
                          } else {
                            setState(() {
                              _enabled = true;
                            });

                            _dragController.forward();
                            widget.onStateChange(_enabled);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.easeInOut,
                          height: height,
                          width: height,
                          decoration: BoxDecoration(
                            color: ballColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }
}
