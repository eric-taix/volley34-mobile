import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
    _favoriteBloc =
        FavoriteBloc(repository: RepositoryProvider.of<Repository>(context))
          ..add(FavoriteLoadEvent());
    _agendaBloc =
        AgendaBloc(repository: RepositoryProvider.of<Repository>(context))
          ..add(AgendaLoadWeek(week: 0));
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
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
    return Padding(
      padding: EdgeInsets.only(top: 55),
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
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
          }),
    );
  }

  Widget _buildDashboardItem(int index, FavoriteState state) {
    switch (index) {
      case 0:
        return Paragraph(
            title: state.teamCodes.length > 1 ? "Vos équipes" : "Votre équipe");
      case 1:
        return Container(height: 120);
      case 2:
        return Paragraph(
            title: state.clubs.length > 1 ? "Vos clubs" : "Votre club");
      case 3:
        return (state is FavoriteLoadedState)
            ? Container(
                height: 200,
                child: PageView.builder(
                  itemCount: state.clubs.length,
                  controller: _pageController,
                  itemBuilder: (context, index) =>
                      FavoriteClubCard(state.clubs[index]),
                ))
            : Container(
                constraints: BoxConstraints(minHeight: 100),
                child: Center(child: CircularProgressIndicator()),
              );
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
                        ...groupBy(
                                agendaState.events, (event) => DateTime(event.date.year, event.date.month, event.date.day))
                            .entries
                            .expand((entry) {
                          return [
                            TimelineItem(date: entry.key, events: [
                            ...entry.value.map((e) {
                              TimelineItemWidget timelineItemWidget = TimelineItemWidget.from(e);
                              return TimelineEvent(
                                child: timelineItemWidget,
                                color: timelineItemWidget.color(),
                              );
                            })
                          ])];
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
