import 'package:v34/models/competition.dart';

String getClassificationCategory(String? division) {
  switch (division) {
    case "EX":
      return "Excellence";
    case "HO":
      return "Honneur";
    case "PR":
      return "Promotion";
    case "AC":
      return "Accession";
    case "L1":
      return "Loisirs 1";
    default:
      return "";
  }
}

String? getClassificationPool(String? pool) {
  if (pool == "0")
    return null;
  else
    return "Poule $pool";
}

String getCompetitionCode(CompetitionPlay competitionPlay) {
  if (competitionPlay.type == PlayType.t_4x4 && competitionPlay.sex == PlaySex.male) {
    return "1";
  } else if (competitionPlay.type == PlayType.t_6x6 && competitionPlay.sex == PlaySex.male) {
    return "2";
  } else if (competitionPlay.type == PlayType.t_4x4 && competitionPlay.sex == PlaySex.mix) {
    return "3";
  } else if (competitionPlay.type == PlayType.t_6x6 && competitionPlay.sex == PlaySex.mix) {
    return "5";
  } else if (competitionPlay.type == PlayType.t_4x4 && competitionPlay.sex == PlaySex.female) {
    return "6";
  } else if (competitionPlay.type == PlayType.t_6x6 && competitionPlay.sex == PlaySex.female) {
    return "7";
  }
  return "";
}
