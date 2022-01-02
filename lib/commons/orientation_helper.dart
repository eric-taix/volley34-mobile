import 'dart:math';

import 'package:flutter/material.dart';

class OrientationHelper extends StatefulWidget {
  final Widget child;

  const OrientationHelper({Key? key, required this.child}) : super(key: key);

  @override
  State<OrientationHelper> createState() => _OrientationHelperState();
}

class _OrientationHelperState extends State<OrientationHelper> with SingleTickerProviderStateMixin {
  bool show = false;

  late AnimationController _controller;
  late Animation _translateAnimation;
  late Animation _skakeAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _translateAnimation = Tween<double>(begin: 0.0, end: 220.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.3, curve: Curves.easeInOut),
    ));
    _skakeAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.6, 1, curve: Curves.easeInOut),
    ));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      Future.delayed(Duration(milliseconds: 3000), () {
        _controller.forward();
      }).then(
        (_) => Future.delayed(Duration(milliseconds: 8000), () {
          _controller.reverse();
        }),
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        widget.child,
        Positioned(
          top: 40,
          right: 20,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              return SizedBox(
                width: _translateAnimation.value,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).textTheme.headline1!.color!.withOpacity(0.2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.rotate(angle: _skakeAnimation.value, child: child);
                        },
                        child: Icon(Icons.stay_primary_landscape_rounded,
                            color: Theme.of(context).textTheme.bodyText2!.color, size: 30),
                      ),
                    ),
                    Text("Tourner votre téléphone", style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
