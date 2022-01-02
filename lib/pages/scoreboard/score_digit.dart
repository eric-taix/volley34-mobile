import 'package:flutter/material.dart';

class ScoreDigit extends StatelessWidget {
  final String value;
  final Color? color;
  final double? elevation;

  const ScoreDigit({Key? key, required this.value, this.color, this.elevation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 4, left: 4),
      child: Card(
        elevation: elevation ?? 10,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              value,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 800,
                                letterSpacing: 0.5,
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.bold,
                                color: color ?? Theme.of(context).textTheme.headline1?.color ?? Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
