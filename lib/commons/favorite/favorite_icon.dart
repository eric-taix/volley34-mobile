import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/repositories/repository.dart';

import 'favorite_bloc.dart';

class FavoriteIcon extends StatefulWidget {
  final bool favorite;
  final FavoriteType favoriteType;
  final String favoriteId;
  final EdgeInsetsGeometry padding;
  final bool reloadFavoriteWhenUpdate;

  FavoriteIcon(this.favoriteId, this.favoriteType, this.favorite,
      {this.padding = const EdgeInsets.only(
        top: 12.0,
        left: 24.0,
        bottom: 12.0,
        right: 24.0,
      ),
      this.reloadFavoriteWhenUpdate = false});

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon>
    with SingleTickerProviderStateMixin {
  FavoriteBloc _favoriteBloc;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = FavoriteBloc(RepositoryProvider.of<Repository>(context),
        widget.favoriteId, widget.favoriteType);
    _favoriteBloc.add(FavoriteLoadEvent());
  }

  @override
  void didUpdateWidget(FavoriteIcon oldWidget) {
    if (widget.reloadFavoriteWhenUpdate) _favoriteBloc.add(FavoriteLoadEvent());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _favoriteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: widget.padding,
        child: BlocBuilder(
          cubit: _favoriteBloc,
          buildWhen: (previousState, currentState) =>
              previousState is FavoriteUninitialized ||
              currentState is FavoriteLoaded,
          builder: (context, state) => LikeButton(
            onTap: (fav) => _performToggleFavorite(fav),
            size: 35,
            circleColor:
                CircleColor(start: Colors.yellowAccent, end: Colors.redAccent),
            bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.redAccent,
              dotSecondaryColor: Colors.yellowAccent,
            ),
            isLiked: state is FavoriteLoaded ? state.favorite : widget.favorite,
            likeBuilder: (bool isLiked) {
              return Icon(
                isLiked ? Icons.star : Icons.star_border,
                color: isLiked
                    ? Colors.orangeAccent
                    : Theme.of(context).textTheme.bodyText1.color,
                size: 26,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _performToggleFavorite(bool favorite) async {
    _favoriteBloc.add(FavoriteUpdateEvent(!favorite));
    return !favorite;
  }
}
