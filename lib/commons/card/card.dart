import 'dart:math' as math;

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:v34/commons/loading.dart';

class TitledCard extends StatefulWidget {
  final Widget icon;
  final String title;
  final Widget body;
  final List<CardAction> actions;

  TitledCard({this.icon, @required this.title, this.body, this.actions}) : assert(title != null);

  @override
  _TitledCardState createState() => _TitledCardState();
}

class _TitledCardState extends State<TitledCard> {
  int _alpha = 0;
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    List<CardAction> mainActions = widget.actions != null ? (widget.actions.length >= 5 ? widget.actions.take(3).toList() : widget.actions) : null;
    List<CardAction> extraActions = widget.actions != null ? (widget.actions.length >= 5 ? widget.actions.skip(3).toList() : null) : null;
    double buttonBarRightPadding = extraActions != null ? 68 : 0;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Opacity(
              opacity: 1,
              child: Column(
                children: [
                  Container(
                    color: TinyColor(Theme.of(context).cardTheme.color).isDark()
                        ? TinyColor(Theme.of(context).cardTheme.color).lighten().color
                        : TinyColor(Theme.of(context).cardTheme.color).darken().color,
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0, left: 18.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.icon != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 18.0),
                              child: widget.icon,
                            ),
                          Text(widget.title, style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, right: 8.0, bottom: 18.0, left: 8.0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      widget.body ??
                          SizedBox(height: 100),
                    ]),
                  ),
                  if (mainActions != null && mainActions.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                          color: TinyColor(Theme.of(context).cardTheme.color).lighten(3).color,
                          border: Border(top: BorderSide(color: TinyColor(Theme.of(context).textTheme.headline6.color).darken(30).color))),
                      child: Padding(
                        padding: EdgeInsets.only(right: buttonBarRightPadding),
                        child: ButtonBar(
                            children: mainActions
                                .map((action) => FlatButton(
                                      child: Icon(action.icon, color: action.iconColor),
                                      onPressed: action.onTap,
                                    ))
                                .toList()),
                      ),
                    ),
                ],
              ),
            ),
            if (extraActions != null && extraActions.isNotEmpty)
              Container(
                  color: Theme.of(context).primaryColor.withAlpha(_alpha),
                  constraints: BoxConstraints.expand(),
                  child: CircularMenu(
                      toggleButtonColor: TinyColor(Theme.of(context).cardTheme.color).lighten(3).color,
                      toggleButtonIconColor: Theme.of(context).textTheme.headline6.color,
                      alignment: Alignment.bottomRight,
                      radius: 90,
                      toggleButtonOnPressed: () => _toggleOpacity(!_open),
                      startingAngleInRadian: math.pi,
                      endingAngleInRadian: 3 * math.pi / 2,
                      toggleButtonPadding: 2,
                      toggleButtonMargin: 0,
                      toggleButtonSize: 30,
                      toggleButtonElevation: 0,
                      items: [
                        ...extraActions
                            .map((extraAction) => CircularMenuItem(
                                iconColor: extraAction.iconColor,
                                icon: extraAction.icon,
                                padding: 0,
                                margin: 0,
                                elevation: 0,
                                color: Colors.transparent,
                                onTap: () {
                                  _toggleOpacity(false);
                                  extraAction.onTap();
                                }))
                            .toList()
                      ])),
          ],
        ),
      ),
    );
  }

  void _toggleOpacity(bool open) {
    setState(() {
      _open = open;
      _alpha = _open ? 200 : 0;
    });
  }
}

class CardAction {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  CardAction({this.icon, this.onTap, this.iconColor});
}
