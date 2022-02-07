import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/cards/rounded_title_card.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/favorite/favorite_icon.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';
import 'package:v34/pages/club/bloc/club_info_cubit.dart';
import 'package:v34/repositories/repository.dart';

class ClubCard extends StatefulWidget {
  final Club club;
  final int index;

  ClubCard(this.club, this.index, {Key? key}) : super(key: key);

  @override
  _ClubCardState createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {
  late final ClubInfoCubit _clubInfoCubit;

  @override
  void initState() {
    super.initState();
    _clubInfoCubit = ClubInfoCubit(repository: RepositoryProvider.of<Repository>(context));
    _clubInfoCubit.loadInfo(widget.club.code!);
  }

  @override
  void didUpdateWidget(covariant ClubCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.club.code != widget.club.code) {
      _clubInfoCubit.loadInfo(widget.club.code!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: RoundedTitledCard(
        title: widget.club.shortName,
        heroTag: "hero-logo-${widget.club.code}",
        logoUrl: widget.club.logoUrl,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.club.name!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              BlocBuilder(
                  bloc: _clubInfoCubit,
                  builder: (_, state) {
                    if (state is ClubInfoLoading) {
                      return Loading(loaderType: LoaderType.CHASING_DOTS);
                    }
                    if (state is ClubInfoLoaded) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 18),
                        child: Text(
                          Intl.plural(state.teamCount,
                              one: "${state.teamCount} équipe",
                              other: "${state.teamCount} équipes",
                              args: [state.teamCount]),
                          textAlign: TextAlign.end,
                        ),
                      );
                    }
                    return SizedBox();
                  }),
            ],
          ),
        ),
        buttonBar: ButtonBar(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: FavoriteIcon(
                widget.club.code,
                FavoriteType.Club,
              ),
            ),
          ],
        ),
        onTap: () => RouterFacade.push(context: context, builder: (_) => ClubDetailPage(widget.club)),
      ),
    );
  }
}
