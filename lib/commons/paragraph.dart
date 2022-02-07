import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? child;
  final double topPadding;
  final double bottomPadding;

  Paragraph({
    this.title,
    this.titleWidget,
    this.child,
    this.topPadding = 40.0,
    this.bottomPadding = 0.0,
  }) : assert(title == null || titleWidget == null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18.0, right: 8.0, top: topPadding, bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: Divider(color: Theme.of(context).textTheme.headline6!.color)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: title != null ? Text(title!, style: Theme.of(context).textTheme.headline6) : titleWidget,
              ),
              Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Divider(color: Theme.of(context).textTheme.headline6!.color),
                  )),
            ],
          ),
          child ?? SizedBox(),
        ],
      ),
    );
  }
}
