import 'dart:math';

import 'package:flutter/material.dart';
import 'package:v34/pages/scoreboard/score_digit.dart';
import 'package:v34/pages/scoreboard/score_movement.dart';

class ScorePanel extends StatefulWidget {
  final int initialValue;
  final Color color;
  final bool enabled;
  final void Function(int)? onValueChanged;
  final int diffPoints;
  const ScorePanel({
    Key? key,
    required this.initialValue,
    required this.color,
    this.enabled = false,
    this.onValueChanged,
    this.diffPoints = 0,
  }) : super(key: key);

  @override
  State<ScorePanel> createState() => _ScorePanelState();
}

class _ScorePanelState extends State<ScorePanel> with SingleTickerProviderStateMixin {
  late int _value;
  late AnimationController _controller;
  late Animation<double> _autoAnimation;
  late Animation<double> _manualAnimation;
  Fling _fling = Fling.none;

  @override
  void initState() {
    _value = widget.initialValue;

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        if (status == AnimationStatus.completed && _fling.direction == FlingDirection.up) {
          // if (widget.onValueChanged != null) {
          //   widget.onValueChanged!(_value+1);
          // }
        } else if (status == AnimationStatus.dismissed && _fling.direction == FlingDirection.down) {
          // if (widget.onValueChanged != null) {
          //   widget.onValueChanged!(_value-1);
          // }
        }
        setState(() {
          _fling = _fling.end();
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
    if (_value != widget.initialValue) {
      _value = widget.initialValue;
      _controller.value = 0;
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
    Animation animation = _fling.type == FlingType.auto
        ? (_fling.direction == FlingDirection.up)
            ? AnimationMax<double>(_autoAnimation, _manualAnimation)
            : AnimationMin<double>(_autoAnimation, _manualAnimation)
        : _manualAnimation;

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => GestureDetector(
              onPanStart: widget.enabled
                  ? (dragStartDetails) {
/*                      if (_controller.isAnimating) {
                        if (_fling.direction == FlingDirection.up) {
                          _controller.value = 1;
                        } else if (_fling.direction == FlingDirection.down) {
                          _controller.value = 0;
                        }
                      }*/
                      if (!_controller.isAnimating) {
                        if (dragStartDetails.localPosition.dy > constraints.maxHeight / 2) {
                          if (_controller.value == 1) {
                            setState(() {});
                            _value++;
                            _controller.value = 0;
                          }
                          _fling = _fling.start(FlingDirection.up, dragStartDetails.localPosition.dy);
                        } else if (dragStartDetails.localPosition.dy < constraints.maxHeight / 2) {
                          if (_controller.value == 0) {
                            setState(() {});
                            _value--;
                            _controller.value = 1;
                          }
                          _fling = _fling.start(FlingDirection.down, dragStartDetails.localPosition.dy);
                        }
                      }
                    }
                  : null,
              onPanUpdate: widget.enabled
                  ? (dragUpdateDetails) {
                      _fling = _fling.update(dragUpdateDetails.localPosition.dy, constraints.maxHeight);
                      _controller.value = _fling.delta;
                    }
                  : null,
              onPanEnd: widget.enabled
                  ? (dragEndDetails) {
                      const double MIN_VELOCITY = 400;
                      if (_fling.direction == FlingDirection.up) {
                        if (_manualAnimation.value > pi ||
                            dragEndDetails.velocity.pixelsPerSecond.dy.abs() > MIN_VELOCITY) {
                          _controller.forward();
                        } else {
                          setState(() {});
                          _fling.auto(direction: FlingDirection.down);
                          _controller.reverse();
                        }
                      } else if (_fling.direction == FlingDirection.down) {
                        if (_manualAnimation.value < pi ||
                            dragEndDetails.velocity.pixelsPerSecond.dy.abs() > MIN_VELOCITY) {
                          _controller.reverse();
                        } else {
                          setState(() {});
                          _fling.auto(direction: FlingDirection.up);
                          _controller.forward();
                        }
                      }
                    }
                  : null,
              child: Stack(
                children: [
                  ScoreDigit(
                    value: "${_value + 1}",
                    color: _getColor(context, 1),
                  ),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        alignment: Alignment.topCenter,
                        origin: Offset(0, 0),
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, -0.0008)
                          ..rotateX(animation.value <= 3 * pi / 2 ? animation.value : 3 * pi / 2),
                        child: ScoreDigit(
                          value: "${animation.value < pi / 2 ? _value : ""}",
                          color: _getColor(context, 0),
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

  Color _getColor(BuildContext context, int inc) {
    return widget.enabled
        ? (widget.diffPoints + inc >= 2 && _value + inc >= 25 ? Colors.green : widget.color)
        : Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5);
  }
}
