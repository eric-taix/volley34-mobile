import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
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
  late Timer? _timer;
  late Stopwatch _watch;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _hostTeam = widget.hostTeam;
    _visitorTeam = widget.visitorTeam;
    _watch = Stopwatch();
  }

  _startPlaying() {
    setState(() {
      _playing = true;
      _timer = Timer.periodic(Duration(seconds: 1), (_) => setState(() {}));
      _watch.start();
    });
  }

  _stopPlaying() {
    setState(() {
      _playing = false;
      _timer?.cancel();
      _watch.stop();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                                child: Column(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 16 / 10,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ScorePanel(
                                              initialValue: _hostSets,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                          ),
                                          Expanded(
                                            child: ScorePanel(
                                              initialValue: _visitorSets,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(_watch.elapsed.toString().split(".").first.padLeft(8, "0"),
                                          style:
                                              Theme.of(context).textTheme.headline6!.copyWith(fontFamily: "OpenSans")),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              FloatingActionButton(
                                                mini: true,
                                                onPressed: _playing ? () => null : null,
                                                child: Text("TM", style: TextStyle(fontWeight: FontWeight.bold)),
                                                backgroundColor: _playing ? null : Colors.grey,
                                              ),
                                              FloatingActionButton(
                                                mini: true,
                                                onPressed: () => _playing ? _stopPlaying() : _startPlaying(),
                                                child: Icon(_playing ? Icons.pause : Icons.play_arrow_rounded),
                                              ),
                                              FloatingActionButton(
                                                mini: true,
                                                onPressed: _playing ? () => null : null,
                                                child: Text("TM", style: TextStyle(fontWeight: FontWeight.bold)),
                                                backgroundColor: _playing ? null : Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Row(
                                    children: [
                                      RoundedNetworkImage(
                                        40,
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
                              ),
                              IconButton(
                                onPressed: _playing ? null : () => _rotateTeam(),
                                icon: SvgPicture.asset(
                                  "assets/double-arrow.svg",
                                  color: _playing
                                      ? Theme.of(context).textTheme.bodyText1!.color
                                      : Theme.of(context).textTheme.bodyText2!.color,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
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
                                        40,
                                        _visitorTeam.clubLogoUrl,
                                        borderSize: 0,
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  ),
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
                                  onValueChanged: (value) {
                                    _hostPoints = value;
                                  },
                                  diffPoints: _hostPoints - _visitorPoints,
                                  enabled: _playing,
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
                                  onValueChanged: (value) {
                                    _visitorPoints = value;
                                  },
                                  diffPoints: _visitorPoints - _hostPoints,
                                  enabled: _playing,
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

  Widget _buildGesturePanel({
    required BuildContext context,
    required int score,
    required Color color,
    required Function(int) onValueChanged,
    required int diffPoints,
    required bool enabled,
  }) {
    return Stack(
      children: [
        ScorePanel(
          initialValue: score,
          color: color,
          enabled: enabled,
          onValueChanged: onValueChanged,
          diffPoints: diffPoints,
        ),
      ],
    );
  }

  void _rotateTeam() {
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

  @override
  AnalyticsRoute get route => AnalyticsRoute.scoreboard;
}
