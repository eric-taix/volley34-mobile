import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';
import 'package:v34/pages/dashboard/blocs/agenda_bloc.dart';
import 'package:v34/pages/dashboard/blocs/favorite_bloc.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/pages/dashboard/dashboard_club_teams.dart';
import 'package:v34/pages/dashboard/fav_club_card.dart';
import 'package:v34/pages/dashboard/widgets/timeline/timeline.dart';
import 'package:v34/pages/dashboard/widgets/timeline/timeline_items.dart';
import 'package:v34/repositories/repository.dart';

import '../preferences_page.dart';

class DashboardPage extends StatefulWidget {
  final double cardHeight = 250;

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  FavoriteBloc _favoriteBloc;
  AgendaBloc _agendaBloc;
  PageController _pageController;
  String _currentClubCode;
  double currentFavoriteClubPage = 0;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = FavoriteBloc(repository: RepositoryProvider.of<Repository>(context))..add(FavoriteLoadEvent());
    _favoriteBloc.skip(1).listen((state) {
      if (state is FavoriteLoadedState) {
        if (state.clubs.length > 0) {
          setState(() {
            _currentClubCode = state.clubs[0].code;
          });
        }
      }
    });
    _agendaBloc = AgendaBloc(repository: RepositoryProvider.of<Repository>(context))..add(AgendaLoadWeek(week: 0));
    _pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {
          currentFavoriteClubPage = _pageController.page;
        });
      });
  }

  @override
  void dispose() {
    _favoriteBloc.close();
    _agendaBloc.close();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _favoriteBloc,
        child: BlocBuilder<FavoriteBloc, FavoriteState>(builder: (context, state) {
          return MainPage(
            title: "Volley34",
            sliver: _buildSliverList(state),
          );
        }));
  }

  void _gotoPreferencesPage() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => PreferencesPage()));
  }

  Widget _buildFavoriteClubCard(FavoriteState state, int index, double distance) {
    var absDistance = distance.abs() > 1 ? 1 : distance.abs();
    return Transform.scale(
      scale: 1.0 - (absDistance > 0.15 ? 0.15 : absDistance),
      child: FavoriteClubCard(
        state.clubs[index],
        () => Router.push(context: context, builder: (_) => ClubDetailPage(state.clubs[index])).then(
          (_) => _favoriteBloc.add(FavoriteLoadEvent()),
        ),
      ),
    );
  }

  SliverList _buildSliverList(FavoriteState state) {
    if (state is FavoriteLoadedState) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildDashboardItem(index, state),
          childCount: 6,
        ),
      );
    } else {
      return SliverList(delegate: SliverChildListDelegate([]));
    }
  }

  Widget _buildDashboardItem(int index, FavoriteState state) {
    switch (index) {
      case 0:
        return Paragraph(
          title: state.clubs.length > 1 ? "Vos clubs" : "Votre club",
        );
      case 1:
        return (state is FavoriteLoadedState)
            ? Column(
                children: <Widget>[
                  Container(
                    height: widget.cardHeight,
                    child: PageView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: state.clubs.length,
                      controller: _pageController,
                      onPageChanged: (pageIndex) => _updateClubTeams(state.clubs[pageIndex].code),
                      itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 0), child: _buildFavoriteClubCard(state, index, currentFavoriteClubPage - index)),
                    ),
                  ),
                  if (state.clubs.length > 1)
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: state.clubs.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        dotColor: Theme.of(context).cardTheme.color,
                        activeDotColor: Theme.of(context).accentColor,
                      ),
                    )
                ],
              )
            : Container(
                constraints: BoxConstraints(minHeight: 100),
                child: Center(child: Loading()),
              );
      case 2:
        return Paragraph(
          title: state.teamCodes.length > 1 ? "Vos équipes" : "Vos équipes",
        );
      case 3:
        return DashboardClubTeams(clubCode: _currentClubCode);
      case 4:
        return Paragraph(
          title: "Votre agenda",
        );
      case 5:
        return BlocBuilder(
            bloc: _agendaBloc,
            builder: (context, agendaState) {
              return Padding(
                padding: const EdgeInsets.only(top: 18, bottom: 28.0),
                child: agendaState is AgendaLoaded
                    ? Timeline([
                        ...groupBy(agendaState.events, (event) => DateTime(event.date.year, event.date.month, event.date.day)).entries.expand((entry) {
                          return [
                            TimelineItem(date: entry.key, events: [
                              ...entry.value.map((e) {
                                TimelineItemWidget timelineItemWidget = TimelineItemWidget.from(e);
                                return TimelineEvent(
                                  child: timelineItemWidget,
                                  color: timelineItemWidget.color(),
                                );
                              })
                            ])
                          ];
                        }),
                      ])
                    : Center(child: Loading()),
              );
            });
      default:
        return Container(
          height: 200,
          child: SizedBox(),
        );
    }
  }

  _updateClubTeams(String clubCode) {
    setState(() {
      _currentClubCode = clubCode;
    });
  }
}
