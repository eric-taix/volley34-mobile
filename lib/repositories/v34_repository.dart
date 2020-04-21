import 'package:dio/dio.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/providers/club_provider.dart';

class V34Repository {
  final ClubProvider _clubProvider;

  V34Repository(this._clubProvider);

  Future<List<Club>> getAllClubs() async {
    Response res = await _clubProvider.getAllClubs();
    if (res.statusCode == 200) {
      return (res.data as List).map((json) => Club.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les clubs');
    }
  }
}
