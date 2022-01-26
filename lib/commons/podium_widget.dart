import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/podium.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/utils/competition_text.dart';

class PodiumWidget extends StatefulWidget {
  final String? title;
  final RankingSynthesis classification;
  final bool currentlyDisplayed;
  final String? highlightedTeamCode;
  final bool showTrailing;

  const PodiumWidget({
    Key? key,
    this.title,
    required this.classification,
    required this.currentlyDisplayed,
    required this.highlightedTeamCode,
    this.showTrailing = true,
  }) : super(key: key);

  @override
  State<PodiumWidget> createState() => _PodiumWidgetState();
}

class _PodiumWidgetState extends State<PodiumWidget> {
  double _cupOpacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _cupOpacity = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var placeValues = widget.classification.ranks?.map((teamClassification) {
          return PlaceValue(teamClassification.teamCode, teamClassification.totalPoints?.toDouble() ?? 0,
              teamClassification.rank ?? -1);
        }).toList() ??
        <PlaceValue>[];
    var totalMatches = widget.classification.ranks?.fold<double>(
            0,
            (previous, teamClassification) =>
                previous + (teamClassification.lostMatches ?? 0) + (teamClassification.wonMatches ?? 0)) ??
        0;
    var highlightedIndex = placeValues.indexWhere((placeValue) => placeValue.id == widget.highlightedTeamCode);
    return FractionallySizedBox(
      widthFactor: MediaQuery.of(context).orientation == Orientation.landscape ? 0.5 : 1,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            height: 50,
            child: AnimatedOpacity(
              opacity: _cupOpacity,
              duration: Duration(milliseconds: 1800),
              curve: Curves.easeInOut,
              child: FaIcon(
                FontAwesomeIcons.trophy,
                size: 44,
                color: _getRankColor(placeValues[highlightedIndex].rank),
              ),
            ),
          ),
          Podium(
            placeValues,
            active: widget.currentlyDisplayed,
            title: widget.title ?? widget.classification.label ?? "",
            highlightedIndex: highlightedIndex,
            promoted: widget.classification.promoted,
            relegated: widget.classification.relegated,
            showPromotedRelegated: totalMatches > 0,
            trailing: widget.showTrailing
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 20, maxWidth: 45),
                          child: CompetitionBadge(
                            showSubTitle: false,
                            competitionCode: widget.classification.competitionCode,
                            labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                          child: Text(
                            "${getDivisionLabel(widget.classification.division)}",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int? rank) {
    switch (rank) {
      case 1:
        return Color(0xffFFD700);
      case 2:
        return Color(0xffC0C0C0);
      case 3:
        return Color(0xff796221);
      default:
        return Colors.transparent;
    }
  }
}
