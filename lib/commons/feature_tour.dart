import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureTour extends StatelessWidget {
  final String featureId;
  final Widget target;
  final String title;
  final List<String> paragraphs;
  final Widget child;

  FeatureTour({this.featureId, Widget target, this.title, this.paragraphs, @required this.child}): this.target = target ?? child;

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      contentLocation: ContentLocation.above,
      featureId: featureId,
      tapTarget: target,
      title: Text(title),
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...paragraphs.expand(
            (paragrah) => [
              Text(paragrah),
              Container(
                height: 10,
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Theme.of(context).cardTheme.color,
      targetColor: Theme.of(context).textTheme.body1.color,
      textColor: Colors.white,
      overflowMode: OverflowMode.extendBackground,
      child: child,
      onDismiss: () async => false,
    );
  }
}
