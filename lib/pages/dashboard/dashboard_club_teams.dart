import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/pages/club-details/blocs/club_teams.bloc.dart';
import 'package:v34/pages/dashboard/blocs/favorite_bloc.dart';
import 'package:v34/pages/dashboard/team_card.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';
import 'package:v34/repositories/repository.dart';

final Random random = Random.secure();

class DashboardClubTeams extends StatefulWidget {
  final String clubCode;
  final double cardHeight = 240;

  DashboardClubTeams({this.clubCode});

  @override
  _DashboardClubTeamsState createState() => _DashboardClubTeamsState();
}

class _DashboardClubTeamsState extends State<DashboardClubTeams> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  PageController _pageController;
  int _currentIndex = 0;
  double _currentTeamPage = 0;
  ClubTeamsBloc _clubTeamsBloc;
  FavoriteBloc _favoriteBloc;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        var nextIndex = _pageController.page.round();
        setState(() => _currentTeamPage = _pageController.page);
        if (nextIndex != _currentIndex) {
          _currentIndex = nextIndex;
        }
      });
    _clubTeamsBloc = ClubTeamsBloc(
      repository: RepositoryProvider.of<Repository>(context),
    );
    _clubTeamsBloc.listen((state) {
      if (state is ClubTeamsLoaded) {
        if (_pageController.hasClients) {
          _currentIndex = 0;
          _pageController.jumpTo(0);
        }
        List<String> favorites = (_favoriteBloc.state as FavoriteLoadedState).teamCodes;
        state.teams.forEach((team) {
          if (favorites.contains(team.code)) team.favorite = true;
        });
        state.teams.sort((team1, team2) {
          if (team1.favorite && !team2.favorite) return -1;
          if (!team1.favorite && team2.favorite)
            return 1;
          else
            return team1.name.compareTo(team2.name);
        });
      }
    });
    _favoriteBloc = BlocProvider.of<FavoriteBloc>(context);
    _favoriteBloc.listen((favoriteState) {
      if (favoriteState is FavoriteLoadedState) {
        _clubTeamsBloc.add(ClubTeamsLoadEvent(clubCode: widget.clubCode));
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(DashboardClubTeams oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clubCode != oldWidget.clubCode) {
      _clubTeamsBloc.add(ClubTeamsLoadEvent(clubCode: widget.clubCode));
    }
  }

  Widget _buildTeamCategory(ClubTeamsLoaded state) {
    String text = state.teams[_currentIndex].favorite ? "Équipes favorites" : "Autres";
    return Container(
      width: 160,
      padding: EdgeInsets.only(right: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(text, style: Theme.of(context).textTheme.bodyText2),
          Divider(
            color: Theme.of(context).textTheme.bodyText2.color,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ClubTeamsBloc, ClubTeamsState>(
      bloc: _clubTeamsBloc,
      builder: (context, state) {
        if (state is ClubTeamsLoaded) {
          return Column(children: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                _buildTeamCategory(state),
                Container(
                    height: widget.cardHeight,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _pageController,
                      itemCount: state.teams.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 0),
                          child: TeamCard(
                            currentlyDisplayed: _currentIndex == index,
                            team: state.teams[index],
                            distance: _currentTeamPage - index,
                            onTap: () => Router.push(context: context, builder: (_) => TeamDetailPage(team: state.teams[index])),
                          ),
                        );
                      },
                    )),
              ],
            ),
            if (state.teams.length > 1)
              Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: state.teams.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        dotColor: Theme.of(context).cardTheme.color,
                        activeDotColor: Theme.of(context).accentColor,
                      ),
                    ),
                  ))
          ]);
        } else if (state is ClubTeamsLoading) {
          return Container(
            height: widget.cardHeight,
            child: Loading(),
          );
        } else {
          return Container(height: widget.cardHeight);
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
