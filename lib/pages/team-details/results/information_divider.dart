import 'package:flutter/material.dart';

class InformationDivider extends StatelessWidget {
  final String title;

  const InformationDivider({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Divider(),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6,),
            ),
          ),
          Expanded(
            flex: 7,
            child: Divider(),
          )
        ],
      ),
    );
  }
}