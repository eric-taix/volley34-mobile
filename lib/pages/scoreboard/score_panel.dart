import 'dart:math';

import 'package:flutter/material.dart';
import 'package:v34/pages/scoreboard/score_digit.dart';
import 'package:v34/pages/scoreboard/score_movement.dart';

class ScorePanel extends StatefulWidget {
  final int initialValue;
  final Color color;
  const ScorePanel({Key? key, required this.initialValue, required this.color}) : super(key: key);

  @override
  State<ScorePanel> createState() => _ScorePanelState();
}

class _ScorePanelState extends State<ScorePanel> with SingleTickerProviderStateMixin {
  late int _value;
  late Color _valueColor;
  late Color _backColor;
  late Color _frontColor;
  late AnimationController _controller;
  late Animation<double> _autoAnimation;
  late Animation<double> _manualAnimation;
  Fling _movement = Fling.none;

  @override
  void initState() {
    _value = widget.initialValue;
    _value = widget.initialValue;
    _valueColor = widget.color;
    _backColor = widget.color;
    _frontColor = widget.color;

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        if ((status == AnimationStatus.completed && _movement.direction == FlingDirection.up) ||
            (status == AnimationStatus.dismissed && _movement.direction == FlingDirection.down)) {
          print("Completed $_value");
        }
        setState(() {
          _movement = _movement.end();
        });
      }
    });

    _autoAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: pi).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: pi, end: 2 * pi).chain(CurveTween(curve: Curves.easeIn)), weight: 50),
    ]).animate(_controller);
    _manualAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ScorePanel oldWidget) {
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => GestureDetector(
              onPanStart: (dragStartDetails) {
                if (!_controller.isAnimating) {
                  if (dragStartDetails.localPosition.dy > constraints.maxHeight / 2) {
                    if (_controller.value == 1) {
                      setState(() {});
                      _value++;
                      _controller.value = 0;
                    }
                    _movement = _movement.start(FlingDirection.up, dragStartDetails.localPosition.dy);
                  } else if (dragStartDetails.localPosition.dy < constraints.maxHeight / 2) {
                    if (_controller.value == 0) {
                      setState(() {});
                      _value--;
                      _controller.value = 1;
                    }
                    _movement = _movement.start(FlingDirection.down, dragStartDetails.localPosition.dy);
                  }
                }
              },
              onPanUpdate: (dragUpdateDetails) {
                _movement = _movement.update(dragUpdateDetails.localPosition.dy, constraints.maxHeight);
                _controller.value = _movement.delta;
              },
              onPanEnd: (dragEndDetails) {
                const double MIN_VELOCITY = 600;
                if (_movement.direction == FlingDirection.up) {
                  if (_manualAnimation.value > pi || dragEndDetails.velocity.pixelsPerSecond.dy.abs() > MIN_VELOCITY) {
                    _controller.forward();
                  } else {
                    setState(() {});
                    _movement.auto(direction: FlingDirection.down);
                    _controller.reverse();
                  }
                } else if (_movement.direction == FlingDirection.down) {
                  if (_manualAnimation.value < pi || dragEndDetails.velocity.pixelsPerSecond.dy.abs() > MIN_VELOCITY) {
                    _controller.reverse();
                  } else {
                    setState(() {});
                    _movement.auto(direction: FlingDirection.up);
                    _controller.forward();
                  }
                }
              },
              child: Stack(
                children: [
                  ScoreDigit(
                    value: "${_value + 1}",
                    color: _valueColor,
                  ),
                  AnimatedBuilder(
                    animation: _autoAnimation,
                    builder: (BuildContext context, Widget? child) {
                      Animation animation = _movement.type == FlingType.auto
                          ? (_movement.direction == FlingDirection.up
                              ? _autoAnimation.value > _manualAnimation.value
                                  ? _autoAnimation
                                  : _manualAnimation
                              : _autoAnimation.value < _manualAnimation.value
                                  ? _autoAnimation
                                  : _manualAnimation)
                          : _manualAnimation;
                      return Transform(
                        alignment: Alignment.topCenter,
                        origin: Offset(0, 0),
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, -0.0008)
                          ..rotateX(animation.value <= 3 * pi / 2 ? animation.value : 3 * pi / 2),
                        child: ScoreDigit(
                          value: "${animation.value < pi / 2 ? _value : ""}",
                          color: _valueColor,
                          elevation: _controller.value == 0 ? 0 : 10,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
