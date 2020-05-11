

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {

  final String title;
  final Widget child;
  final double topPadding;

  Paragraph({this.title, this.child, double topPadding}): this.topPadding = topPadding ?? 44.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18.0, right: 8.0, top: topPadding, bottom: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.title),
          child ?? SizedBox(),
        ],
      ),
    );
  }
}