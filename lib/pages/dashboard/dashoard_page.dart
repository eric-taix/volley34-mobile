import 'package:collection/collection.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/commons/feature_tour.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';
import 'package:v34/pages/dashboard/blocs/agenda_bloc.dart';
import 'package:v34/pages/dashboard/blocs/favorite_bloc.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/pages/dashboard/fav_club_card.dart';
import 'package:v34/pages/dashboard/widgets/timeline/timeline.dart';
import 'package:v34/pages/dashboard/widgets/timeline/timeline_items.dart';
import 'package:v34/repositories/repository.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  FavoriteBloc _favoriteBloc;
  AgendaBloc _agendaBloc;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = FavoriteBloc(repository: RepositoryProvider.of<Repository>(context))..add(FavoriteLoadEvent());
    _agendaBloc = AgendaBloc(repository: RepositoryProvider.of<Repository>(context))..add(AgendaLoadWeek(week: 0));
    _pageController = PageController(initialPage: 0);
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
    return BlocBuilder<FavoriteBloc, FavoriteState>(
        bloc: _favoriteBloc,
        builder: (context, state) {
          return (state is FavoriteLoadedState)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return _buildDashboardItem(
                      index,
                      state,
                    );
                  },
                )
              : SizedBox();
        });
  }

  Widget _buildDashboardItem(int index, FavoriteState state) {
    switch (index) {
      case 0:
        return Paragraph(title: state.clubs.length > 1 ? "Vos clubs" : "Votre club");
      case 1:
        return (state is FavoriteLoadedState)
            ? Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: PageView.builder(
                      itemCount: state.clubs.length,
                      controller: _pageController,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 16),
                        child: FavoriteClubCard(
                          state.clubs[index],
                          () => Router.push(context: context, builder: (_) => ClubDetailPage(state.clubs[index])).then(
                            (_) => _favoriteBloc.add(FavoriteLoadEvent()),
                          ),
                        ),
                      ),
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
                child: Center(child: CircularProgressIndicator()),
              );
      case 2:
        return Paragraph(title: state.teamCodes.length > 1 ? "Vos équipes" : "Votre équipe");
      case 3:
        return Container(height: 120);
      case 4:
        return Paragraph(title: "Votre agenda");
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
                    : Center(child: CircularProgressIndicator()),
              );
            });
      default:
        return Container(
          height: 200,
          child: SizedBox(),
        );
    }
  }
}
