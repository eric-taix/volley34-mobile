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
          colorFilter: ColorFilter.mode(
            Theme.of(context).bottomAppBarTheme.color ?? Colors.white,
            BlendMode.srcIn,
          ),
          semanticsLabel: title,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
