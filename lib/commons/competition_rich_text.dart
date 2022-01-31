import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/utils/competition_text.dart';

class CompetitionRichText extends StatelessWidget {
  final String? competitionCode;
  final bool showText;
  final bool showBadge;
  final bool blackAndWhite;
  final bool allowDetails;
  final List<Competition> competitions;

  const CompetitionRichText({
    Key? key,
    required this.competitionCode,
    this.showText = false,
    this.blackAndWhite = false,
    this.showBadge = false,
    required this.allowDetails,
    required this.competitions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Competition? competition = competitions.firstWhereOrNull((competition) => competition.code == competitionCode);

    return competition != null
        ? Container(
            decoration: BoxDecoration(
              color: allowDetails ? Theme.of(context).cardTheme.color : Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1,
                color: allowDetails ? Colors.transparent : Theme.of(context).cardTheme.color!,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showBadge)
                    CompetitionBadge(
                      showSubTitle: false,
                      competitionCode: competitionCode,
                      labelStyle: TextStyle(color: Colors.white, fontSize: 9),
                      blackAndWhite: blackAndWhite,
                    ),
                  if (showText)
                    IgnorePointer(
                      ignoring: false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 8.0, bottom: 8.0),
                        child: Text(
                          extractEnhanceDivisionLabel(competition.competitionLabel),
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        : SizedBox(height: 18);
  }
}
