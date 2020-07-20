import 'package:flutter/material.dart';

class InformationDivider extends StatelessWidget {
  final String title;

  const InformationDivider({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(title, style: Theme.of(context).textTheme.headline6,)
          ),
          Divider()
        ],
      ),
    );
  }
}