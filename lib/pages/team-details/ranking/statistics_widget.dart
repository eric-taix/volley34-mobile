import 'package:flutter/material.dart';
import 'package:v34/commons/graphs/arc.dart';

class StatisticsWidget extends StatefulWidget {
  final String title;
  final int? points;
  final int? diffPoints;
  final int maxPoints;
  final Color? backgroundColor;

  const StatisticsWidget({
    Key? key,
    required this.points,
    this.diffPoints,
    required this.title,
    required this.maxPoints,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<StatisticsWidget> createState() => _StatisticsWidgetState();
}

class _StatisticsWidgetState extends State<StatisticsWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRatio(BuildContext context, int point) {
    return RichText(
      textScaleFactor: 1.2,
      textAlign: TextAlign.center,
      text: new TextSpan(
        text: "$point",
        style: new TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText2!.color,
        ),
        children: <TextSpan>[
          new TextSpan(text: ' / ${(widget.maxPoints)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildGraph(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ArcGraph(
        minValue: 0,
        maxValue: widget.maxPoints.toDouble(),
        value: widget.points!.toDouble(),
        lineWidth: 8,
        backgroundColor: widget.backgroundColor,
        leftTitle: LeftTitle(
          show: false,
        ),
        valueBuilder: (value, minValue, maxValue) {
          var percentage = maxValue != 0 ? "${(value * 100).toStringAsFixed(1)}%" : "- -";
          return Text(percentage);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Text(widget.title, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1),
          )),
          Expanded(child: _buildRatio(context, (_animation.value * widget.points).toInt())),
          Expanded(child: _buildGraph(context)),
        ],
      ),
    );
  }
}
