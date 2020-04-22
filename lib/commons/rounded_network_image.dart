import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedNetworkImage extends StatelessWidget {
  final double _size;
  final String _imageUrl;

  static const double borderSize = 7;

  RoundedNetworkImage(this._size, this._imageUrl);

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: _size + (2 * borderSize),
        height: _size + (2 * borderSize),
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).bottomAppBarColor,
          border: Border.all(color: Theme.of(context).cardTheme.color, width: borderSize),
        ),
      child: CachedNetworkImage(fit: BoxFit.scaleDown, imageUrl: _imageUrl),
    );
  }
}
