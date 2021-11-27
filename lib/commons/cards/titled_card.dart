import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:v34/utils/extensions.dart';

class TitledCard extends StatelessWidget {
  final Widget? icon;
  final String title;
  final Widget? body;
  final List<CardAction>? actions;
  final VoidCallback? onTap;
  final ButtonBar? buttonBar;
  final EdgeInsetsGeometry? bodyPadding;
  final double elevation;
  final EdgeInsetsGeometry? margin;

  TitledCard(
      {this.icon,
      required this.title,
      this.body,
      this.actions,
      this.onTap,
      this.buttonBar,
      this.bodyPadding,
      this.elevation = 0,
      this.margin});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        margin: margin,
        elevation: elevation,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardTheme.titleBackgroundColor(context)),
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0, left: 18.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (icon != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: icon,
                          ),
                        Expanded(
                            child: Text(
                          title,
                          style: Theme.of(context).textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        )),
                        Icon(Icons.arrow_forward_ios, color: Theme.of(context).textTheme.caption!.color, size: 12),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: bodyPadding ?? const EdgeInsets.only(top: 18.0, right: 8.0, bottom: 18.0, left: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      body ?? SizedBox(height: 100),
                    ]),
                  ),
                ),
                if (actions != null && actions!.isNotEmpty)
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).cardTheme.color, //(Theme.of(context).cardTheme.color).lighten(3).color,
                        border: Border(
                            top: BorderSide(
                                color: TinyColor(Theme.of(context).textTheme.headline6!.color!).darken(30).color))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions!
                              .map((action) => SizedBox(
                                    width: 50,
                                    child: FlatButton(
                                      splashColor: Colors.white.withOpacity(0.3),
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.zero,
                                      child: Icon(action.icon,
                                          color: action.iconColor ?? Theme.of(context).textTheme.headline6!.color),
                                      onPressed: action.onTap,
                                    ),
                                  ))
                              .toList()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      if (buttonBar != null)
        Positioned(
          right: 30,
          top: 30,
          child: buttonBar!,
        )
    ]);
  }
}

class CardAction {
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  CardAction({this.icon, this.onTap, this.iconColor});
}
