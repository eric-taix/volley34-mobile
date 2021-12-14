import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/favorite/favorite.dart';

class FavoriteIcon extends StatelessWidget {
  final FavoriteType favoriteType;
  final String? favoriteId;
  final EdgeInsetsGeometry padding;

  FavoriteIcon(
    this.favoriteId,
    this.favoriteType, {
    this.padding = const EdgeInsets.only(
      top: 8.0,
      left: 24.0,
      bottom: 0.0,
      right: 8.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: BlocBuilder<PreferencesBloc, PreferencesState>(
        builder: (context, dynamic state) => (favoriteType == FavoriteType.Club &&
                    state.favoriteClub != null &&
                    state.favoriteClub!.code == favoriteId) ||
                (favoriteType == FavoriteType.Team && state.favoriteTeam!.code == favoriteId)
            ? Icon(
                Icons.star,
                color: Colors.orangeAccent,
              )
            : SizedBox(),
      ),
    );
  }
}
