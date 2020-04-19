

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoData extends StatelessWidget {

  final String title;

  NoData(this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SvgPicture.asset(
          "assets/volleyball-filled.svg",
          height: 80,
          color: Theme.of(context).bottomAppBarColor,
          semanticsLabel: title,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(title, style: Theme.of(context).textTheme.body2),
        ),
      ],
    );
  }

}