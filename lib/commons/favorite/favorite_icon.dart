import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/repositories/repository.dart';

class FavoriteIcon extends StatefulWidget {
  final bool favorite;
  final FavoriteType favoriteType;
  final String favoriteId;
  final EdgeInsetsGeometry padding;

  FavoriteIcon(this.favoriteId, this.favoriteType, this.favorite,
      {this.padding = const EdgeInsets.only(
        top: 12.0,
        left: 24.0,
        bottom: 12.0,
        right: 24.0,
      )});

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon>
    with SingleTickerProviderStateMixin {
  Repository _repository;
  bool _favorite;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _favorite = widget.favorite;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _performToggleFavorite(),
      child: Padding(
        padding: widget.padding,
        child: Icon(
          _favorite ? Icons.star : Icons.star_border,
          size: 26,
          color: _favorite
              ? Colors.yellow
              : Theme.of(context).textTheme.body2.color,
        ),
      ),
    );
  }

  void _performToggleFavorite() {
    setState(() {
      _favorite = !_favorite;
      _repository.updateFavorite(
          widget.favoriteId, widget.favoriteType, _favorite);
    });
  }
}
