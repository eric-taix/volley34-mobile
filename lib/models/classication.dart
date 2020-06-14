class ClassificationTeamSynthesis {
  final String teamCode;
  final int totalPoints;
  final int rank;

  ClassificationTeamSynthesis(this.teamCode, this.rank, this.totalPoints);

  factory ClassificationTeamSynthesis.fromJson(Map<String, dynamic> json) {
    return ClassificationTeamSynthesis(json["EquipeCode"], json["Rang"], json["Total"]);
  }
}

class ClassificationSynthesis {
  final int promoted;
  final int relegated;
  final String label;
  final List<ClassificationTeamSynthesis> teamsClassifications;

  ClassificationSynthesis(this.label, this.promoted, this.relegated, this.teamsClassifications);

  factory ClassificationSynthesis.fromJson(Map<String, dynamic> json) {
    return ClassificationSynthesis(
      _getLabel(json["Libelle"]),
      json["Promus"],
      json["Relegue"],
      (json["classementDetail"] as List<dynamic>).map((detail) => ClassificationTeamSynthesis.fromJson(detail)).toList(),
    );
  }

  static String _getLabel(String label) {
    var extractedLabel  = label.split(" ")[0];
    return extractedLabel;
  }
}
