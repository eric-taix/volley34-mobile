import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
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

class _FavoriteIconState extends State<FavoriteIcon> with SingleTickerProviderStateMixin {
  Repository _repository;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: widget.padding,
        child: LikeButton(
          onTap: (fav) => _performToggleFavorite(fav),
          size: 35,
          circleColor: CircleColor(start: Colors.yellowAccent, end: Colors.redAccent),
          bubblesColor: BubblesColor(
            dotPrimaryColor: Colors.redAccent,
            dotSecondaryColor: Colors.yellowAccent,
          ),
          isLiked: widget.favorite,
          likeBuilder: (bool isLiked) {
            return Icon(
              isLiked ? Icons.star : Icons.star_border,
              color: isLiked ? Colors.yellow : Theme
                  .of(context)
                  .textTheme
                  .body2
                  .color,
              size: 26,
            );
          },
        ),
      ),
    );
  }

  Future<bool> _performToggleFavorite(bool favorite) async {
    await _repository.updateFavorite(widget.favoriteId, widget.favoriteType, !favorite);
    return !favorite;
  }
}
