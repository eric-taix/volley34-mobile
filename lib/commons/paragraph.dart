

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {

  final String title;
  final Widget child;

  Paragraph({this.title, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 8.0, top: 44.0, bottom: 28.0),
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