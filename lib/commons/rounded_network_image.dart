import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:v34/utils/extensions.dart';

class RoundedNetworkImage extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final double borderSize;
  final Color? circleColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  RoundedNetworkImage(this.size, this.imageUrl,
      {this.borderSize = 7, this.circleColor, this.backgroundColor, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + (2 * borderSize) - 1,
      height: size + (2 * borderSize) - 1,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: circleColor ?? Theme.of(context).appBarTheme.backgroundColor!, width: borderSize)),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Theme.of(context).cardTheme.titleBackgroundColor(context),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(4),
          child: imageUrl != null
              ? CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: imageUrl!,
                  errorWidget: (_, __, ___) => SizedBox(),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
