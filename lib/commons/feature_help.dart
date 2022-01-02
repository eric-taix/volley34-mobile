import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureHelp extends StatelessWidget {
  final String featureId;
  final Widget? target;
  final String? title;
  final List<String>? paragraphs;
  final List<Widget>? paragraphsChildren;
  final ContentLocation contentLocation;
  final Widget child;
  final Future<bool> Function()? onComplete;

  FeatureHelp({
    required this.featureId,
    this.target,
    this.title,
    this.paragraphs,
    required this.child,
    this.onComplete,
    this.paragraphsChildren,
    this.contentLocation = ContentLocation.above,
  }) : assert(paragraphs == null || paragraphsChildren == null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            Expanded(
              child: DescribedFeatureOverlay(
                contentLocation: contentLocation,
                featureId: featureId,
                barrierDismissible: true,
                backgroundDismissible: true,
                tapTarget: target ??
                    SizedBox(
                      height: 2,
                      width: 2,
                    ),
                onComplete: onComplete,
                title: Text(title ?? "",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Theme.of(context).textTheme.bodyText1!.color)),
                description: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (paragraphs != null)
                      ...paragraphs!.expand(
                        (paragraph) => [
                          Text(
                            paragraph,
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
                overflowMode: OverflowMode.wrapBackground,
                child: child,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
