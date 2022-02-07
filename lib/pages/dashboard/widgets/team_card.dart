import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/team_classification_bloc.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';
import 'package:v34/repositories/repository.dart';

import '../../../commons/router.dart';

class TeamCard extends StatefulWidget {
  final Team team;
  final Club? club;
  final bool currentlyDisplayed;
  final double distance;
  final double cardHeight;
  TeamCard({
    required this.team,
    required this.currentlyDisplayed,
    required this.distance,
    required this.club,
    this.cardHeight = 190,
  });

  @override
  _TeamCardState createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
  late TeamRankingBloc _rankingBloc;
  final _currentPageNotifier = ValueNotifier<int>(0);
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _rankingBloc = TeamRankingBloc(repository: RepositoryProvider.of<Repository>(context));
    if (widget.currentlyDisplayed) {
      _rankingBloc.add(LoadTeamRankingEvent(widget.team));
    }
  }

  @override
  void didUpdateWidget(TeamCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // !oldWidget.active -> to avoid several calls to the API when sliding
    // which can create a visual bug
    if (widget.currentlyDisplayed &&
        ((widget.team.clubCode != oldWidget.team.clubCode) || !oldWidget.currentlyDisplayed)) {
      _rankingBloc.add(LoadTeamRankingEvent(widget.team));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _rankingBloc.close();
  }

  Widget _noPodiumData(BuildContext context) {
    return Center(
        child: Text(
      "Aucune donnée",
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText1,
    ));
  }

  Widget _getPodiumWidgets(state) {
    if (state is TeamRankingLoadedState) {
      return state.rankings.length != 0
          ? Stack(
              children: [
                ArrowPageIndicator(
                  currentPageNotifier: _currentPageNotifier,
                  pageController: _pageController,
                  itemCount: state.rankings.length,
                  iconPadding: EdgeInsets.only(top: 92),
                  iconColor: Theme.of(context).colorScheme.secondary,
                  isInside: true,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (pageIndex) => _currentPageNotifier.value = pageIndex,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 8.0, bottom: 18),
                        child: PodiumWidget(
                          showTrailing: true,
                          classification: state.rankings[index],
                          highlightedTeamCode: state.highlightedTeamCode,
                          currentlyDisplayed: widget.currentlyDisplayed,
                        ),
                      );
                    },
                    itemCount: state.rankings.length,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AnimatedCirclePageIndicator(
                    itemCount: state.rankings.length > 1 ? state.rankings.length : 0,
                    currentPageNotifier: _currentPageNotifier,
                    radius: 4,
                    activeRadius: 3,
                    fillColor: Colors.transparent,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    spacing: 8,
                    borderColor: Theme.of(context).colorScheme.secondary,
                    borderWidth: 1,
                    duration: Duration(milliseconds: 100),
                  ),
                ),
              ],
            )
          : _noPodiumData(context);
    } else if (state is TeamRankingLoadingState) {
      return Center(child: Loading(loaderType: LoaderType.THREE_BOUNCE));
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    var absDistance = widget.distance.abs() > 1 ? 1 : widget.distance.abs();
    return BlocConsumer<TeamRankingBloc, TeamRankingState>(
      bloc: _rankingBloc,
      listener: (context, state) {
        if (state is TeamRankingLoadedState && state.firstShownCompetition != null) {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            var index = state.rankings.indexWhere((ranking) => ranking.competitionCode == state.firstShownCompetition);
            if (_pageController.hasClients && index != -1) _pageController.jumpToPage(index);
          });
        }
      },
      builder: (context, state) {
        return Transform.scale(
          scale: 1.0 - (absDistance > 0.15 ? 0.15 : absDistance),
          child: TitledCard(
            title: widget.team.name!,
            bodyPadding: EdgeInsets.only(bottom: 12),
            body: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 0.0),
              child: Container(
                height: widget.cardHeight,
                child: _getPodiumWidgets(state),
              ),
            ),
            onTap: () => RouterFacade.push(
              context: context,
              builder: (_) => TeamDetailPage(
                teamCode: widget.team.code!,
                teamName: widget.team.name!,
                club: widget.club,
                openedPage:
                    state is TeamRankingLoadedState && _pageController.hasClients ? OpenedPage.COMPETITION : null,
                openedCompetitionCode: state is TeamRankingLoadedState && _pageController.hasClients
                    ? state.rankings[_pageController.page!.toInt()].competitionCode
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
