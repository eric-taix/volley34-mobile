import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LandscapeHelper extends StatefulWidget {
  const LandscapeHelper({Key? key}) : super(key: key);

  @override
  State<LandscapeHelper> createState() => _LandscapeHelperState();
}

class _LandscapeHelperState extends State<LandscapeHelper> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _skakeAnimation;
  late Animation _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _skakeAnimation = Tween<double>(begin: pi / 2, end: 2.0 * pi).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.4, 1, curve: Curves.bounceOut),
    ));
    _opacityAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0, 0.5, curve: Curves.easeInOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation != Orientation.landscape
        ? Padding(
            padding: EdgeInsets.only(top: 18),
            child: VisibilityDetector(
              key: Key("landscape-helper"),
              onVisibilityChanged: (VisibilityInfo info) {
                Future.delayed(Duration(milliseconds: 300), () {
                  if (mounted) _controller.forward();
                });
              },
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 1500),
                opacity: _opacityAnimation.value,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.rotate(angle: _skakeAnimation.value, child: child);
                        },
                        child: Icon(Icons.stay_primary_landscape_rounded,
                            color: Theme.of(context).textTheme.bodyText1!.color!),
                      ),
                    ),
                    Text(
                      "Tournez pour plus de détails",
                      style:
                          TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).textTheme.bodyText1!.color!),
                    ),
                  ],
                ),
              ),
            ))
        : SizedBox(height: 18);
  }
}
