

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {

  final double size;

  Loading({this.size = 30});

  @override
  Widget build(BuildContext context) {
    return new SpinKitChasingDots(
      color: Theme.of(context).textTheme.headline6.color,
      size: size,
    );
  }

  factory Loading.small() {
    return Loading(size: 15);
  }

}