class Gymnasium {
  final String gymnasiumCode;
  final String name;
  final String address;
  final String postalCode;
  final String district;
  final String town;
  final String phone;
  final int courtCount;
  final double latitude;
  final double longitude;
  final String fullname;

  Gymnasium({
    this.gymnasiumCode,
    this.name,
    this.address,
    this.postalCode,
    this.district,
    this.town,
    this.phone,
    this.courtCount,
    this.latitude,
    this.longitude,
    this.fullname,
  });
  
  factory Gymnasium.fromJson(Map<String, dynamic> json) {
    var gps = (json["GPS"] as String)?.split("|");
    return Gymnasium(
      gymnasiumCode: json["GymnaseCode"],
      name: json["Nom"],
      address: json["Adresse"],
      postalCode: json["CP"],
      district: json["Quartier"],
      town: json["Ville"],
      phone: json["Telephone"],
      courtCount: json["Terrains"],
      latitude: gps != null ? double.parse(gps[0].replaceAll(',', '.')) : null,
      longitude: gps != null ? double.parse(gps[1].replaceAll(',', '.')) : null,
      fullname: json["NomComplet"],
    );
  }
}
