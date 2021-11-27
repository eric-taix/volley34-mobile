class MatchesPlayed {
  final int total;
  final int won;

  factory MatchesPlayed.empty() {
    return MatchesPlayed(won: 0, total: 0);
  }

  MatchesPlayed({required this.won, required this.total});

  operator +(MatchesPlayed matchesPlayed) =>
      MatchesPlayed(won: won + matchesPlayed.won, total: total + matchesPlayed.total);
}
