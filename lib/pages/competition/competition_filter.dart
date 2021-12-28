import 'package:v34/models/competition.dart';
import 'package:v34/models/division.dart';

class CompetitionFilter {
  static const String ALL_COMPETITION = "all_competition";

  final String competitionGroup;
  final CompetitionPlay competitionPlay;
  final Division competitionDivision;

  static final all = CompetitionFilter(
      competitionGroup: ALL_COMPETITION, competitionPlay: CompetitionPlay.all, competitionDivision: Division.all);

  CompetitionFilter({required this.competitionGroup, required this.competitionPlay, required this.competitionDivision});

  CompetitionFilter copyWith(
      {String? competitionGroup, CompetitionPlay? competitionPlay, Division? competitionDivision}) {
    return CompetitionFilter(
        competitionGroup: competitionGroup ?? this.competitionGroup,
        competitionPlay: competitionPlay ?? this.competitionPlay,
        competitionDivision: competitionDivision ?? this.competitionDivision);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompetitionFilter &&
          runtimeType == other.runtimeType &&
          competitionGroup == other.competitionGroup &&
          competitionPlay == other.competitionPlay &&
          competitionDivision == other.competitionDivision;

  @override
  int get hashCode => competitionGroup.hashCode ^ competitionPlay.hashCode ^ competitionDivision.hashCode;

  int get count =>
      (competitionGroup != ALL_COMPETITION ? 1 : 0) +
      (competitionPlay != CompetitionPlay.all ? 1 : 0) +
      (competitionDivision != Division.all ? 1 : 0);
}
