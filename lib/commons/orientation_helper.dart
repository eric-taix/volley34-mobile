import 'dart:math';

import 'package:flutter/material.dart';

class OrientationHelper extends StatefulWidget {
  final Widget child;
  final String title;
  final double? top;
  final double? bottom;
  final double right;
  final double width;
  const OrientationHelper(
      {Key? key,
      required this.child,
      this.title = "Tourner votre téléphone",
      this.top,
      this.right = 20,
      this.bottom,
      this.width = 220})
      : super(key: key);

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
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 4000));
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    _translateAnimation = Tween<double>(begin: -widget.width, end: widget.right).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.3, curve: Curves.elasticOut),
    ));
    _skakeAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.8, 1, curve: Curves.easeInOut),
    ));
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      Future.delayed(Duration(milliseconds: 2000), () {
        if (mounted) _controller.forward();
      }).then(
        (_) => Future.delayed(Duration(milliseconds: 4000), () {
          if (mounted) _controller.reverse();
        }),
      );
    } else {
      if (mounted) _controller.reset();
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
          top: widget.top,
          right: _translateAnimation.value,
          bottom: widget.bottom,
          child: SizedBox(
            width: widget.width,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).bottomAppBarTheme.color,
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
                        child:
                            Icon(Icons.stay_primary_landscape_rounded, color: Theme.of(context).canvasColor, size: 30),
                      ),
                    ),
                    Expanded(
                      child: Text(widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).canvasColor)),
                    ),
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
