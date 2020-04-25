class Team {
  String code;
  String competition;
  String clubCode;
  String name;
  String division;
  String pool;
  int season;
  String competitionType;
  String clubLogoUrl;
  String mailing;
  bool favorite = false;

  Team({
    this.code,
    this.competition,
    this.clubCode,
    this.name,
    this.division,
    this.pool,
    this.season,
    this.competitionType,
    this.clubLogoUrl,
    this.mailing,
    this.favorite = false,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(code: json["EquipeCode"],
        competition: json["CompetitionCode"],
        clubCode: json["ClubCode"],
        name: json["NomEquipe"],
        division: json["Division"],
        pool: json["Poule"],
        season: json["Saison"],
        competitionType: json["TypeCompetition"],
        clubLogoUrl: json["URLLogoClub"],
        mailing: json["Mailing"]);
  }

  bool toggleFavorite() {
    favorite = !favorite;
    return favorite;
  }

  @override
  String toString() {
    return 'Team{code: $code, name: $name}';
  }
}
