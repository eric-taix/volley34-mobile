class Division {
  final String code;
  final String label;
  final String id;
  final bool active;

  Division({required this.code, required this.label, required this.id, required this.active});

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      code: json["CodeValueListCode"],
      label: json["CodeValueListValue"],
      id: json["CodeValueListRankItem"].toString(),
      active: json["CodeValueListActiveItem"] == "true",
    );
  }
}
