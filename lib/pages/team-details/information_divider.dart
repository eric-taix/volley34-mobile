import 'package:flutter/material.dart';

class InformationDivider extends StatelessWidget {
  final String title;
  final double? size;

  const InformationDivider({Key? key, required this.title, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = this.size ?? 20;
    TextStyle style = Theme.of(context).textTheme.headline6!.apply(fontSizeFactor: 0.0, fontSizeDelta: size);
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0 + 200 - size*10, top: 32.0, bottom: 16.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(title, style: style)
          ),
          Divider(color: Theme.of(context).textTheme.headline6!.color,)
        ],
      ),
    );
  }
}