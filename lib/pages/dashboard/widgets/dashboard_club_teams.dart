import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_teams.bloc.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';
import 'package:v34/pages/dashboard/widgets/team_card.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';
import 'package:v34/repositories/repository.dart';

typedef TeamFavoriteChangeCallback = void Function(Team team);

class DashboardClubTeams extends StatefulWidget {
  final Club club;
  final double cardHeight = 240;
  final TeamFavoriteChangeCallback onTeamFavoriteChange;

  const DashboardClubTeams({@required this.club, this.onTeamFavoriteChange});

  @override
  _DashboardClubTeamsState createState() => _DashboardClubTeamsState();
}

class _DashboardClubTeamsState extends State<DashboardClubTeams> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // AutomaticKeepAliveClientMixin permits to preserve this state when scrolling on the dashboard

  PageController _pageController;
  int _currentIndex = 0;
  double _currentTeamPage = 0;
  ClubTeamsBloc _clubTeamsBloc;

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
      if (state is ClubTeamsLoaded && _pageController.hasClients) {
        _currentIndex = 0;
        _pageController.jumpTo(0);
      }
    });
    _loadFavoriteTeams();
    super.initState();
  }

  @override
  void didUpdateWidget(DashboardClubTeams oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadFavoriteTeams();
  }

  void _loadFavoriteTeams() {
    _clubTeamsBloc.add(ClubFavoriteTeamsLoadEvent(widget.club.code));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ClubTeamsBloc, ClubTeamsState>(
      bloc: _clubTeamsBloc,
      builder: (context, state) {
        if (state is ClubTeamsLoaded) {
          return Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Container(
              height: widget.cardHeight,
              child: state.teams.length > 0
                  ? PageView.builder(
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
                            onTap: () => Router.push(context: context, builder: (_) => TeamDetailPage(team: state.teams[index]))
                                .then((_) => widget.onTeamFavoriteChange(state.teams[index])),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: RaisedButton(
                          onPressed: () =>  Router.push(context: context, builder: (_) => ClubDetailPage(widget.club)).then(
                            (_) => widget.onTeamFavoriteChange(null),
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Sélectionnez une équipe favorite",
                          ),
                        ),
                      ),
                    ),
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
