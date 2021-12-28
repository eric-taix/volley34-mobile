class Division {
  final String code;
  final String label;
  final String id;
  final bool active;

  static final all = Division(code: "all", label: "all", id: "all", active: true);

  Division({required this.code, required this.label, required this.id, required this.active});

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Division && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
      code: json["CodeValueListCode"],
      label: json["CodeValueListValue"],
      id: json["CodeValueListRankItem"].toString(),
      active: json["CodeValueListActiveItem"] == "true",
    );
  }
}
