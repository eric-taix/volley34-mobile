import 'package:flutter/material.dart';
import 'package:v34/commons/app_bar/app_bar.dart';

import '../rounded_network_image.dart';

class AnimatedLogo extends StatefulWidget {
  final double? expandedHeight;
  final String? imageUrl;
  final String? heroTag;
  final Function(double, double)? compute;

  AnimatedLogo({this.expandedHeight, this.imageUrl, this.heroTag, this.compute});

  @override
  __AnimatedLogoState createState() => __AnimatedLogoState();
}

class __AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _animationController.addListener(() {
      setState(() {});
    });

    TweenSequence<double> animations = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 70).chain(CurveTween(curve: Curves.easeOut)), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 70, end: 0).chain(CurveTween(curve: Curves.bounceOut)), weight: 1)
    ]);

    _logoAnimation = animations.animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.compute!(kSystemBarHeight + 10, widget.expandedHeight! - widget.compute!(0, 12)) -
          _logoAnimation.value,
      left: widget.compute!(50, 25),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).appBarTheme.backgroundColor!, width: 0),
          shape: BoxShape.circle,
        ),
        child: Hero(
          tag: widget.heroTag!,
          child: RoundedNetworkImage(
            widget.compute!(38, 60),
            widget.imageUrl,
            borderSize: widget.compute!(0, 10),
            //circleColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
