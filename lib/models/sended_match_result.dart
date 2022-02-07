class SendedMatchResult {
  final String code;
  final String label;
  final SendedMatchResultStatus status;
  final String comment;

  SendedMatchResult({required this.code, required this.label, required this.status, required this.comment});

  factory SendedMatchResult.fromJson(Map<String, dynamic> json) {
    return SendedMatchResult(
      code: json["MatchCode"],
      label: json["LibelleMatch"],
      status: _toEnumType(json["Status"]),
      comment: json["Commentaire"],
    );
  }
  static SendedMatchResultStatus _toEnumType(String status) {
    switch (status) {
      case "OK":
        return SendedMatchResultStatus.OK;
      case "OK_WIN_LOCALS":
        return SendedMatchResultStatus.OK_WIN_LOCALS;
      case "OK_WIN_VISITORS":
        return SendedMatchResultStatus.OK_WIN_VISITORS;
      case "KO":
        return SendedMatchResultStatus.KO;
      case "KO_INVALID_SCORE":
        return SendedMatchResultStatus.KO_INVALID_SCORE;
      case "KO_INVALID_SET_NUM":
        return SendedMatchResultStatus.KO_INVALID_SET_NUM;
    }
    return SendedMatchResultStatus.UNKNOWN;
  }
}

enum SendedMatchResultStatus { OK, OK_WIN_LOCALS, OK_WIN_VISITORS, KO, KO_INVALID_SET_NUM, KO_INVALID_SCORE, UNKNOWN }
