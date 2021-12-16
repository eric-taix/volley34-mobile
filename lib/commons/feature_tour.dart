import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureTour extends StatelessWidget {
  final String featureId;
  final Widget? target;
  final String? title;
  final List<String>? paragraphs;
  final List<Widget>? paragraphsChildren;

  final Widget child;
  final Future<bool> Function()? onComplete;

  FeatureTour(
      {required this.featureId,
      this.target,
      this.title,
      this.paragraphs,
      required this.child,
      this.onComplete,
      this.paragraphsChildren})
      : assert(paragraphs == null || paragraphsChildren == null);

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      contentLocation: ContentLocation.above,
      featureId: featureId,
      tapTarget: target ?? SizedBox(),
      onComplete: onComplete,
      title: Text(title ?? "",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Theme.of(context).textTheme.bodyText1!.color)),
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (paragraphs != null)
            ...paragraphs!.expand(
              (paragrah) => [
                Text(
                  paragrah,
                  style: Theme.of(context).textTheme.bodyText2,
                  textScaleFactor: 1.2,
                ),
                Container(
                  height: 10,
                ),
              ],
            ),
          if (paragraphsChildren != null) ...paragraphsChildren!,
        ],
      ),
      backgroundColor: Theme.of(context).cardTheme.color,
      backgroundOpacity: 0.85,
      targetColor: Theme.of(context).textTheme.bodyText2!.color!,
      textColor: Colors.red,
      overflowMode: OverflowMode.extendBackground,
      child: child,
      onDismiss: () async => false,
    );
  }
}
