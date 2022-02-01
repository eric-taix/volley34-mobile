import 'package:v34/models/competition.dart';

String getDivisionLabel(String? division) {
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
    case "L2":
      return "Loisirs 2";
    case "L3":
      return "Loisirs 3";
    case "L4":
      return "Loisirs 4";
    case "L5":
      return "Loisirs 5";
    case "L6":
      return "Loisirs 6";
    default:
      return "";
  }
}

String extractEnhanceDivisionLabel(String fullLabel) {
  List<String> parts = fullLabel.split(" ");
  return parts
      .where((part) => int.tryParse(part) == null)
      .where((part) => part != "-")
      .where((part) => part != "4x4" && part != "6x6")
      .where((part) => part != "Masculin" && part != "Féminin" && part != "Mixte")
      .join(" ");
}

int getDivisionOrder(String? division) {
  switch (division) {
    case "EX":
      return 1;
    case "HO":
      return 2;
    case "PR":
      return 3;
    case "AC":
      return 4;
    case "L1":
      return 5;
    case "L2":
      return 6;
    case "L3":
      return 7;
    case "L4":
      return 8;
    case "L5":
      return 9;
    case "L6":
      return 10;
    default:
      return 100;
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
