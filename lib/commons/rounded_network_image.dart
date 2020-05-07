import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedNetworkImage extends StatelessWidget {
  final double size;
  final String imageUrl;
  final double borderSize;

  RoundedNetworkImage(this.size, this.imageUrl , {this.borderSize = 7});

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: size + (2 * borderSize),
        height: size + (2 * borderSize),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).bottomAppBarColor,
          border: Border.all(color: Theme.of(context).cardTheme.color, width: borderSize),
        ),
      child: CachedNetworkImage(fit: BoxFit.scaleDown, imageUrl: imageUrl),
    );
  }
}
