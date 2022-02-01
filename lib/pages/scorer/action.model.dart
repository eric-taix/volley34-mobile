enum ScoreActionType {
  serve_point,
  serve_error,
  reception_error,
  attack_point,
  attack_blocked,
  attack_error,
  block_point,
  generic_error,
  opponent_error,
  opponent_point,
}

enum ScoreAttitude {
  positive,
  negative,
}

enum ScoreDirection {
  from_team,
  to_team,
  both,
}

class ScoreAction {
  final String title;
  final ScoreActionType type;
  final ScoreAttitude attitude;
  final ScoreDirection direction;

  const ScoreAction._({required this.title, required this.type, required this.attitude, required this.direction});
}

const SERVE_POINT = ScoreAction._(
  title: "Service gagnant",
  type: ScoreActionType.serve_point,
  attitude: ScoreAttitude.positive,
  direction: ScoreDirection.from_team,
);
const SERVE_ERROR = ScoreAction._(
  title: "Faute de service",
  type: ScoreActionType.serve_error,
  attitude: ScoreAttitude.negative,
  direction: ScoreDirection.from_team,
);
const RECEPTION_ERROR = ScoreAction._(
  title: "Faute de réception",
  type: ScoreActionType.reception_error,
  attitude: ScoreAttitude.negative,
  direction: ScoreDirection.to_team,
);
const ATTACK_POINT = ScoreAction._(
  title: "Attaque gagnante",
  type: ScoreActionType.attack_point,
  attitude: ScoreAttitude.positive,
  direction: ScoreDirection.from_team,
);
const ATTACK_BLOCKED = ScoreAction._(
  title: "Attaque bloquée",
  type: ScoreActionType.attack_blocked,
  attitude: ScoreAttitude.negative,
  direction: ScoreDirection.from_team,
);
const ATTACK_ERROR = ScoreAction._(
  title: "Faute d'attaque",
  type: ScoreActionType.attack_error,
  attitude: ScoreAttitude.negative,
  direction: ScoreDirection.from_team,
);
const BLOCK_POINT = ScoreAction._(
  title: "Contre gagnant",
  type: ScoreActionType.block_point,
  attitude: ScoreAttitude.positive,
  direction: ScoreDirection.to_team,
);
const GENERIC_ERROR = ScoreAction._(
  title: "Autre faute",
  type: ScoreActionType.generic_error,
  attitude: ScoreAttitude.negative,
  direction: ScoreDirection.both,
);
const OPPONENT_ERROR = ScoreAction._(
  title: "Faute de l'adversaire",
  type: ScoreActionType.opponent_error,
  attitude: ScoreAttitude.positive,
  direction: ScoreDirection.to_team,
);
const OPPONENT_POINT = ScoreAction._(
  title: "Point de l'adversaire",
  type: ScoreActionType.opponent_point,
  attitude: ScoreAttitude.negative,
  direction: ScoreDirection.to_team,
);
