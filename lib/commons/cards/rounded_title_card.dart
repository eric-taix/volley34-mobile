


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/rounded_network_image.dart';

class RoundedTitledCard extends StatelessWidget {

  final String title;
  final VoidCallback onTap;
  final Widget body;
  final String heroTag;
  final String logoUrl;
  final ButtonBar buttonBar;

  RoundedTitledCard({this.title, this.onTap, this.body, this.heroTag, this.logoUrl, this.buttonBar});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TitledCard(
          icon: SizedBox(width: 10),
          title: title,
          onTap: onTap,
          body: body,
          buttonBar: buttonBar,
        ),
        Positioned(
          top: 16,
          child: Hero(
            tag: heroTag,
            child: RoundedNetworkImage(
              40,
              logoUrl,
              circleColor: TinyColor(Theme.of(context).cardTheme.color).isDark()
                  ? TinyColor(Theme.of(context).cardTheme.color).lighten().color
                  : TinyColor(Theme.of(context).cardTheme.color).darken().color,
            ),
          ),
        )
      ],
    );
  }

}