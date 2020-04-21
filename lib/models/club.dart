

class Club {
  String code;
  String name;
  String contact;
  String phone;
  String websiteUrl;
  String email;
  String acronym;
  String logoUrl;
  String shortName;
  String address1;
  String address2;
  String address3;
  String postalCode;
  String town;
  String facebook;
  String twitter;
  String instagram;
  String snapchat;
  bool active;
  bool ffvb;
  bool favorite = false;
  Club();
  
  factory Club.fromJson(Map<String, dynamic> json) {
    return Club()
        ..code = json["CodeClub"]
      ..name = json["NomClub"]
      ..contact = json["ContactClub"]
      ..phone = json["TelephoneClub"]
      ..websiteUrl = json["URLClub"]
      ..email = json["MailClub"]
      ..acronym = json["SigleClub"]
      ..logoUrl = json["URLLogoClub"]
      ..shortName = json["NomClubCourt"]
      ..address1 = json["AdresseClub1"]
      ..address2 = json["AdresseClub2"]
      ..address3 = json["AdresseClub3"]
      ..postalCode = json["CodePostalClub"]
      ..town = json["VilleClub"]
      ..facebook = json["Facebook"]
      ..twitter = json["Twitter"]
      ..instagram = json["Instagram"]
      ..snapchat = json["Snapchat"]
      ..active = json["isActive"] != null && json["isActive"] == "true"
      ..ffvb = json["isFFVB"] != null && json["isFFVB"] == "true"
    ;
  }

  bool toggleFavorite() {
    favorite = !favorite;
    return favorite;
  }

  @override
  String toString() {
    return 'Club{code: $code, name: $name}';
  }


}