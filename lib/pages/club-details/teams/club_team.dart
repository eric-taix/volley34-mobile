import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';
import 'package:page_view_indicators/arrow_page_indicator.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/favorite/favorite_icon.dart';
import 'package:v34/commons/graphs/arc.dart';
import 'package:v34/commons/graphs/line_graph.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/team_detail_page.dart';
import 'package:v34/repositories/repository.dart';

import '../../../commons/router.dart';

class ClubTeam extends StatefulWidget {
  final Team team;
  final Club club;

  ClubTeam({required this.team, required this.club});

  @override
  _ClubTeamState createState() => _ClubTeamState();
}

class _ClubTeamState extends State<ClubTeam> {
  TeamBloc? _teamBloc;
  final _currentPageNotifier = ValueNotifier<int>(0);
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: false);
    _teamBloc = TeamBloc(repository: RepositoryProvider.of<Repository>(context))
      ..add(TeamLoadAverageSlidingResult(team: widget.team, last: 100, count: 1));
  }

  @override
  void dispose() {
    super.dispose();
    _teamBloc!.close();
  }

  @override
  Widget build(BuildContext context) {
    final double miniGraphHeight = 80;
    return BlocBuilder<TeamBloc, TeamState>(
      bloc: _teamBloc,
      builder: (context, state) => TitledCard(
        title: widget.team.name!,
        bodyPadding: EdgeInsets.only(top: 18, bottom: 8, right: 0, left: 0),
        onTap: state is TeamSlidingStatsLoaded
            ? () => RouterFacade.push(
                  context: context,
                  builder: (_) => TeamDetailPage(
                    team: widget.team,
                    club: widget.club,
                    openedPage: OpenedPage.COMPETITION,
                    openedCompetitionCode: state.competitions.keys.toList()[_pageController.page!.toInt()],
                  ),
                )
            : null,
        buttonBar: ButtonBar(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: FavoriteIcon(
                widget.team.code,
                FavoriteType.Team,
              ),
            ),
          ],
        ),
        body: Container(
          height: 300,
          child: (state is TeamSlidingStatsLoaded)
              ? Stack(
                  children: [
                    AnimatedBuilder(
                        animation: _currentPageNotifier,
                        builder: (_, __) {
                          return ArrowPageIndicator(
                            currentPageNotifier: _currentPageNotifier,
                            pageController: _pageController,
                            iconSize: state.competitions.length > 1 ? ArrowPageIndicator.defaultIconSize : 0,
                            itemCount: state.competitions.length > 1 ? state.competitions.length : 0,
                            iconPadding: EdgeInsets.only(bottom: 12),
                            iconColor: Theme.of(context).colorScheme.secondary,
                            isInside: true,
                            child: PageView(
                              key: PageStorageKey("club-team-${widget.team.code}"),
                              controller: _pageController,
                              onPageChanged: (pageIndex) {
                                _currentPageNotifier.value = pageIndex;
                              },
                              children: [
                                ...state.competitions
                                    .map(
                                      (competitionCode, competition) {
                                        return MapEntry(
                                            competitionCode,
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                              child: Column(
                                                children: <Widget>[
                                                  ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(minHeight: 160, maxHeight: 160, maxWidth: 540),
                                                      child: PodiumWidget(
                                                        classification: competition.rankingSynthesis ??
                                                            RankingSynthesis(competitionCode: competitionCode),
                                                        currentlyDisplayed: true,
                                                        highlightedTeamCode: widget.team.code,
                                                        showTrailing: true,
                                                      )),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(
                                                                  left: 16, top: 8, right: 0, bottom: 8),
                                                              child: SizedBox(
                                                                height: miniGraphHeight,
                                                                child: LineGraph(
                                                                  competition.pointsDiffEvolution ?? [],
                                                                  thumbnail: true,
                                                                  title: "Diff. Sets",
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 8.0),
                                                              child: Align(
                                                                alignment: Alignment.center,
                                                                child: ConstrainedBox(
                                                                  constraints:
                                                                      BoxConstraints(maxHeight: 100, maxWidth: 80),
                                                                  child: ArcGraph(
                                                                    minValue: 0,
                                                                    maxValue: 1,
                                                                    backgroundColor: Theme.of(context).cardTheme.color,
                                                                    value: competition.totalMatches != null &&
                                                                            competition.totalMatches != 0
                                                                        ? (competition.wonMatches?.toDouble() ?? 0.0) /
                                                                            (competition.totalMatches?.toDouble() ?? 1)
                                                                        : 0,
                                                                    leftTitle: LeftTitle(
                                                                        text: "Victoires",
                                                                        style: Theme.of(context).textTheme.bodyText1),
                                                                    valueBuilder: (value, min, max) => RichText(
                                                                      textScaleFactor: 1.0,
                                                                      textAlign: TextAlign.center,
                                                                      text: new TextSpan(
                                                                        text:
                                                                            "${(value * (competition.totalMatches?.toDouble() ?? 0.0)).toInt()}",
                                                                        style: new TextStyle(
                                                                          fontSize: 24.0,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText2!
                                                                              .color,
                                                                        ),
                                                                        children: <TextSpan>[
                                                                          new TextSpan(
                                                                              text:
                                                                                  ' / ${competition.totalMatches ?? 0}',
                                                                              style: TextStyle(
                                                                                  fontSize: 12,
                                                                                  fontWeight: FontWeight.normal)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      },
                                    )
                                    .values
                                    .toList(),
                              ],
                            ),
                          );
                        }),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedCirclePageIndicator(
                        itemCount: state.competitions.length > 1 ? state.competitions.length : 0,
                        currentPageNotifier: _currentPageNotifier,
                        radius: 4,
                        activeRadius: 3,
                        fillColor: Colors.transparent,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        spacing: 8,
                        borderColor: Theme.of(context).colorScheme.secondary,
                        borderWidth: 1,
                      ),
                    ),
                  ],
                )
              : Loading(),
        ),
      ),
    );
  }
}
