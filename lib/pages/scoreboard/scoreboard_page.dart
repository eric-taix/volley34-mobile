import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/scoreboard/score_movement.dart';
import 'package:v34/pages/scoreboard/score_panel.dart';
import 'package:v34/utils/analytics.dart';

class ScoreBoardPage extends StatefulWidget {
  final Team hostTeam;
  final Club hostClub;
  final Team visitorTeam;
  final Club visitorClub;

  const ScoreBoardPage({
    Key? key,
    required this.hostTeam,
    required this.hostClub,
    required this.visitorTeam,
    required this.visitorClub,
  }) : super(key: key);

  @override
  State<ScoreBoardPage> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> with RouteAwareAnalytics {
  late int _hostPoints = 20;
  late Color _hostColor;
  late int _visitorPoints = 3;
  late Color _visitorColor;
  late int _hostSets = 2;
  late int _visitorSets = 1;
  late Team _hostTeam;
  late Team _visitorTeam;
  Fling? _hostScoreMovement;
  Fling? _visitorMovement;

  @override
  void initState() {
    super.initState();
    _hostTeam = widget.hostTeam;
    _visitorTeam = widget.visitorTeam;
  }

  @override
  void didChangeDependencies() {
    _hostColor = Theme.of(context).textTheme.headline1!.color!;
    _visitorColor = Theme.of(context).textTheme.headline1!.color!;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const int POINTS_FLEX = 5;
    const int SETS_FLEX = 4;

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) => SafeArea(
        child: Scaffold(
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: POINTS_FLEX, child: SizedBox()),
                              Expanded(
                                flex: SETS_FLEX,
                                child: FractionallySizedBox(
                                  heightFactor: 0.4,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ScorePanel(
                                              initialValue: _hostSets, color: Theme.of(context).colorScheme.secondary)),
                                      Expanded(
                                          child: ScorePanel(
                                              initialValue: _visitorSets,
                                              color: Theme.of(context).colorScheme.secondary)),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(flex: POINTS_FLEX, child: SizedBox()),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    RoundedNetworkImage(
                                      50,
                                      _hostTeam.clubLogoUrl,
                                      borderSize: 0,
                                      backgroundColor: Colors.transparent,
                                      padding: EdgeInsets.zero,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8, right: 8),
                                        child: Text(_hostTeam.name!, style: Theme.of(context).textTheme.bodyText1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _rotateTeam(),
                                icon: SvgPicture.asset(
                                  "assets/double-arrow.svg",
                                  color: Theme.of(context).textTheme.headline1!.color,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: Text(_visitorTeam.name!,
                                          textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodyText1),
                                    )),
                                    RoundedNetworkImage(
                                      50,
                                      _visitorTeam.clubLogoUrl,
                                      borderSize: 0,
                                      backgroundColor: Colors.transparent,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: POINTS_FLEX,
                                child: _buildGesturePanel(
                                  context: context,
                                  score: _hostPoints,
                                  color: _hostColor,
                                  movement: _hostScoreMovement,
                                  onMovementStart: (type, initialPosition) => setState(() {
                                    _updateColors();
                                  }),
                                  onMovementUpdate: (position, height) =>
                                      setState(() => _hostScoreMovement = _hostScoreMovement?.update(position, height)),
                                  onMovementEnd: (velocity) => setState(() {}),
                                ),
                              ),
                              Expanded(
                                flex: SETS_FLEX,
                                child: SizedBox(),
                              ),
                              Expanded(
                                flex: POINTS_FLEX,
                                child: _buildGesturePanel(
                                  context: context,
                                  score: _visitorPoints,
                                  color: _visitorColor,
                                  movement: _visitorMovement,
                                  onMovementStart: (_, __) => null,
                                  onMovementUpdate: (_, __) => null,
                                  onMovementEnd: (_) => null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGesturePanel(
      {required BuildContext context,
      required int score,
      required Color color,
      required Fling? movement,
      required Function(FlingType, double initialDelta) onMovementStart,
      required Function(double, double) onMovementUpdate,
      required Function(Velocity) onMovementEnd}) {
    return Stack(
      children: [
        ScorePanel(
          initialValue: score,
          color: color,
        ),
        /*LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              onVerticalDragStart: (dragStartDetails) => onMovementStart(
                  dragStartDetails.localPosition.dy < constraints.maxHeight / 2
                      ? ScoreMovementType.down
                      : ScoreMovementType.up,
                  dragStartDetails.localPosition.dy),
              onVerticalDragUpdate: (dragUpdateDetails) =>
                  onMovementUpdate(dragUpdateDetails.localPosition.dy, constraints.maxHeight),
              onVerticalDragEnd: (dragEndDetails) => onMovementEnd(dragEndDetails.velocity),
            );
          },
        ),*/
      ],
    );
  }

  void _rotateTeam() {
    const int DELAY = 100;
    setState(() {
      int sets = _hostSets;
      int points = _hostPoints;
      Color color = _hostColor;
      Team team = _hostTeam;
      setState(() {
        _hostPoints = _visitorPoints;
        _hostSets = _visitorSets;
        _hostColor = _visitorColor;
        _hostTeam = _visitorTeam;
        _visitorSets = sets;
        _visitorSets = sets;
        _visitorPoints = points;
        _visitorColor = color;
        _visitorTeam = team;
      });
    });
  }

  void _updateColors() {
    if (_hostPoints >= 25 && (_hostPoints - _visitorPoints >= 2)) {
      _hostColor = Colors.green;
    } else {
      _hostColor = Theme.of(context).textTheme.headline1!.color!;
    }
    if (_visitorPoints >= 25 && (_visitorPoints - _hostPoints >= 2)) {
      _visitorColor = Colors.green;
    } else {
      _visitorColor = Theme.of(context).textTheme.headline1!.color!;
    }
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.scoreboard;
}
