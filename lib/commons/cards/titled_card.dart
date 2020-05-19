import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class TitledCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final Widget body;
  final List<CardAction> actions;
  final VoidCallback onTap;
  final ButtonBar buttonBar;
  final EdgeInsetsGeometry bodyPadding;

  TitledCard({this.icon, @required this.title, this.body, this.actions, this.onTap, this.buttonBar, this.bodyPadding}) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: TinyColor(Theme.of(context).cardTheme.color).isDark()
                        ? TinyColor(Theme.of(context).cardTheme.color).lighten(3).color
                        : TinyColor(Theme.of(context).cardTheme.color).darken(3).color,
                    //  border: Border(bottom: BorderSide(color: TinyColor(Theme.of(context).textTheme.headline6.color).darken(30).color))
                  ),
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
                        Text(title, style: Theme.of(context).textTheme.caption),
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
                if (actions != null && actions.isNotEmpty)
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color, //(Theme.of(context).cardTheme.color).lighten(3).color,
                        border: Border(top: BorderSide(color: TinyColor(Theme.of(context).textTheme.headline6.color).darken(30).color))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: actions
                              .map((action) => SizedBox(
                                    width: 50,
                                    child: FlatButton(
                                      splashColor: Colors.white.withOpacity(0.3),
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.zero,
                                      child: Icon(action.icon, color: action.iconColor ?? Theme.of(context).textTheme.headline6.color),
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
          child: buttonBar,
        )
    ]);
  }
}

class CardAction {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  CardAction({this.icon, this.onTap, this.iconColor});
}
