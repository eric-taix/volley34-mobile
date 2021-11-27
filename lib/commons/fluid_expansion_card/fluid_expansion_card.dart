import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Global variable to access the status of the card.
StatusBloc fluidExpansionCard = StatusBloc();

class FluidExpansionCard extends StatefulWidget {
  final Color? color;
  final double width;
  final double topCardHeight;
  final double bottomCardHeight;
  final double borderRadius;
  final Widget? topCardWidget;
  final Widget? bottomCardWidget;
  final bool slimeEnabled;

  FluidExpansionCard({
    this.color = const Color(0xff5858FF),
    this.width = 300,
    this.topCardHeight = 300,
    this.bottomCardHeight = 300,
    this.borderRadius = 25,
    this.topCardWidget,
    this.bottomCardWidget,
    this.slimeEnabled = true,
  })  : assert(topCardHeight >= 80, 'Height of Top Card must be atleast 150.'),
        assert(bottomCardHeight >= 100, 'Height of Bottom Card must be atleast 100.'),
        assert(width >= 100, 'Width must be atleast 100.'),
        assert(borderRadius <= 30 && borderRadius >= 0, 'Border Radius must neither exceed 30 nor be negative');

  @override
  _FluidExpansionCardState createState() => _FluidExpansionCardState();
}

class _FluidExpansionCardState extends State<FluidExpansionCard> with TickerProviderStateMixin {
  late bool isSeparated;

  double? bottomDimension;
  double? initialBottomDimension;
  double? finalBottomDimension;
  double? gap;
  double? gapInitial;
  double? gapFinal;
  late double x;
  double? y;
  String? activeAnimation;
  Widget? topCardWidget;
  Widget? bottomCardWidget;

  late Animation<double> arrowAnimation;
  late AnimationController arrowAnimController;
  late AnimationController detailsController;
  late Animation<double> detailsAnimation;

  /// `action` is the main function that triggers the process of separation of
  /// the cards and vice-versa.
  ///
  /// It also updates the status of the SlimyCard.

  void action() {
    if (isSeparated) {
      isSeparated = false;
      fluidExpansionCard.updateStatus(false);
      arrowAnimController.reverse();
      detailsController.reverse(from: 1.0);
      gap = gapInitial;
      bottomDimension = initialBottomDimension;
    } else {
      isSeparated = true;
      fluidExpansionCard.updateStatus(true);
      arrowAnimController.forward();
      detailsController.forward(from: 0.0);
      gap = gapFinal;
      bottomDimension = finalBottomDimension;
    }

    activeAnimation = (activeAnimation == 'Idle') ? 'Action' : 'Idle';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isSeparated = false;
    activeAnimation = 'Idle';
    initialBottomDimension = widget.topCardHeight;
    finalBottomDimension = widget.bottomCardHeight;
    bottomDimension = initialBottomDimension;
    topCardWidget =
        (widget.topCardWidget != null) ? widget.topCardWidget : simpleTextWidget('This is Top Card Widget.');
    bottomCardWidget =
        (widget.bottomCardWidget != null) ? widget.bottomCardWidget : simpleTextWidget('This is Bottom Card Widget.');
    arrowAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    arrowAnimation = Tween<double>(begin: 0, end: 0.5).animate(arrowAnimController);

    const cardsMargin = 15;
    x = (widget.borderRadius < 10) ? 10 : widget.borderRadius;
    y = (widget.borderRadius < 2) ? 2 : widget.borderRadius;
    gapInitial = ((widget.topCardHeight - x - widget.bottomCardHeight / 4) > 0)
        ? (widget.topCardHeight - x - widget.bottomCardHeight / 4)
        : 0;
    gapFinal = ((widget.topCardHeight + x - widget.bottomCardHeight / 4 + cardsMargin) > 0)
        ? (widget.topCardHeight + x - widget.bottomCardHeight / 4 + cardsMargin)
        : 2 * x + cardsMargin;
    gapInitial = 0;
    gapFinal = widget.topCardHeight;
    gap = gapInitial;
    detailsController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800), reverseDuration: Duration(milliseconds: 400));
    detailsAnimation = Tween<double>(begin: gapInitial, end: gapFinal).animate(CurvedAnimation(
      parent: detailsController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    arrowAnimController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FluidExpansionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.topCardWidget != null) {
        topCardWidget = widget.topCardWidget;
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    double detailsDistance = 20;
    double switchRadius = 46;
    double switchPadding = 8;
    double slimeWidth = widget.width - widget.borderRadius * 4;
    double slimeHeight = detailsDistance;
    return GestureDetector(
        onTap: () {
          setState(() {
            action();
          });
        },
        child: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Column(
                children: <Widget>[
                  AnimatedBuilder(
                    animation: detailsController,
                    builder: (BuildContext context, Widget? child) {
                      return Container(
                        height: detailsAnimation.value,
                      );
                    },
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    overflow: Overflow.clip,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: bottomDimension,
                          width: widget.width,
                          decoration: BoxDecoration(
                            color: widget.color,
                            borderRadius: BorderRadius.circular(widget.borderRadius),
                          ),
                          alignment: Alignment.center,
                          child: AnimatedOpacity(
                            duration: Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                            opacity: (isSeparated) ? 1.0 : 0,
                            child: ClipRect(
                              clipper: BottomClip(initialBottomDimension, finalBottomDimension, !isSeparated),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: bottomCardWidget,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Flare animation
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: FlareActor(
                              'assets/flare/bottomSlime.flr',
                              color: widget.color!.withOpacity((widget.slimeEnabled) ? 1 : 0),
                              animation: activeAnimation,
                              sizeFromArtboard: true,
                              alignment: Alignment.bottomCenter,
                              fit: BoxFit.fill,
                            ),
                            height: slimeHeight,
                            width: slimeWidth,
                          ),
                          SizedBox(
                            // Determine the height of the topCard
                            height: bottomDimension! - 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  // Top card widget
                  Container(
                    height: widget.topCardHeight,
                    width: widget.width,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    alignment: Alignment.center,
                    child: topCardWidget,
                  ),
                  // Flare other animation
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: widget.topCardHeight,
                      ),
                      Container(
                        height: slimeHeight,
                        width: slimeWidth,
                        child: FlareActor(
                          'assets/flare/topSlime.flr',
                          color: widget.color!.withOpacity((widget.slimeEnabled) ? 1 : 0),
                          animation: activeAnimation,
                          sizeFromArtboard: true,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              // Arrow
              Column(
                children: <Widget>[
                  SizedBox(
                    height: widget.topCardHeight - switchRadius / 2 + detailsDistance / 2,
                  ),
                  Container(
                    height: switchRadius,
                    width: switchRadius,
                    alignment: Alignment.center,
                    child: RotationTransition(
                      turns: arrowAnimation,
                      child: Container(
                        height: switchRadius - switchPadding,
                        width: switchRadius - switchPadding,
                        alignment: Alignment.center,
                        child: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).accentColor),
                        decoration: BoxDecoration(
                          color: Theme.of(context).buttonColor,
                          borderRadius: BorderRadius.circular(switchRadius / 2),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(switchRadius / 2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

/// `simpleTextWidget` is a place-holder Widget that can be replaced with
/// `topCardWidget` & `bottomCardWidget`.

Widget simpleTextWidget(String text) {
  return Center(
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

/// This is stream(according to BLoC) which enables to update real-time status
/// of SlimyCard

class StatusBloc {
  var statusController = StreamController<bool>.broadcast();

  Function(bool) get updateStatus => statusController.sink.add;

  Stream<bool> get stream => statusController.stream;

  dispose() {
    statusController.close();
  }
}

class BottomClip extends CustomClipper<Rect> {
  final double? minheight;
  final double? maxheight;
  final bool clip;

  BottomClip(this.minheight, this.maxheight, this.clip);

  @override
  Rect getClip(Size size) {
    return Offset.zero & (clip ? Size(size.width, minheight! - 105) : Size(size.width, maxheight!));
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return (oldClipper is BottomClip) ? oldClipper.clip != this.clip : true;
  }
}
