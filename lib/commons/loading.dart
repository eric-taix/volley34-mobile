import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum LoaderType { CHASING_DOTS, THREE_BOUNCE }

class Loading extends StatelessWidget {
  final double size;
  final LoaderType? loaderType;

  Loading({this.size = 30, this.loaderType});

  @override
  Widget build(BuildContext context) {
    switch (loaderType) {
      case LoaderType.THREE_BOUNCE:
        return new SpinKitThreeBounce(
          color: Theme.of(context).textTheme.headline6!.color,
          size: size,
        );
      case LoaderType.CHASING_DOTS:
      default:
        return new SpinKitChasingDots(
          color: Theme.of(context).textTheme.headline6!.color,
          size: size,
        );
    }
  }

  factory Loading.small() {
    return Loading(size: 15);
  }
}
