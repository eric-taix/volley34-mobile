

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

  final double size;
  final Widget loader;

  Loading({this.size = 30, this.loader});

  @override
  Widget build(BuildContext context) {
    if(this.loader == null) {
      return new SpinKitChasingDots(
        color: Theme.of(context).textTheme.headline6.color,
        size: size,
      );
    }
    else return this.loader;
  }

  factory Loading.small() {
    return Loading(size: 15);
  }

  factory Loading.threeBounce({@required Color color, double size = 30}) {
    return Loading(
      loader: SpinKitThreeBounce(
        color: color,
        size: size,
      ),
    );
  }

}