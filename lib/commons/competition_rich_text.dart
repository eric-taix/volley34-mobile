import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/competition_text.dart';

class CompetitionRichText extends StatefulWidget {
  final String? competitionCode;
  final bool showText;
  final bool showBadge;
  final bool blackAndWhite;

  const CompetitionRichText(
      {Key? key,
      required this.competitionCode,
      this.showText = false,
      this.blackAndWhite = false,
      this.showBadge = false})
      : super(key: key);

  @override
  State<CompetitionRichText> createState() => _CompetitionRichTextState();
}

class _CompetitionRichTextState extends State<CompetitionRichText> {
  List<Competition>? _competitions;

  @override
  void initState() {
    super.initState();
    Repository repository = RepositoryProvider.of<Repository>(context);
    repository.loadAllCompetitions().then((competitions) {
      setState(() {
        _competitions = competitions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Competition? competition;
    if (_competitions != null) {
      competition = _competitions!.firstWhereOrNull((competition) => competition.code == widget.competitionCode);
    }

    return competition != null
        ? Container(
            decoration:
                BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.showBadge)
                    SizedBox(
                      height: 16,
                      width: 34,
                      child: CompetitionBadge(
                        showSubTitle: false,
                        competitionCode: widget.competitionCode,
                        labelStyle: TextStyle(color: Colors.white, fontSize: 9),
                        blackAndWhite: widget.blackAndWhite,
                      ),
                    ),
                  if (widget.showText)
                    IgnorePointer(
                      ignoring: false,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0, bottom: 12.0),
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
