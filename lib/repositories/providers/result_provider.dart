import 'package:dio/dio.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/sended_match_result.dart';

import 'http.dart';

class ResultProvider {
  ResultProvider();

  Future<List<MatchResult>> loadResults(String competition, String? division, String? pool) async {
    assert(pool == null || division != null, "Can't request pool result without division");
    String url = "/resultats/$competition";
    if (division != null) url += "/$division";
    if (pool != null) url += "/$pool";
    Response response = await dio.get(url);
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => MatchResult.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les résultats');
    }
  }

  Future<SendedMatchResult> sendResult({
    required String matchCode,
    required List<String> sets,
    String? comment,
    required String senderName,
    required String senderTeamName,
    required String senderEmail,
    String? matchSheetFilename,
    String? matchSheetFileBase64,
  }) async {
    var data = {
      "Id": matchCode,
      "LicencesLocaux": [],
      "LicencesVisiteurs": [],
      "Sets": [
        {"Id": 1, "Locaux": sets[0].isNotEmpty ? sets[0] : null, "Visiteur": sets[1].isNotEmpty ? sets[1] : null},
        {"Id": 2, "Locaux": sets[2].isNotEmpty ? sets[2] : null, "Visiteur": sets[3].isNotEmpty ? sets[3] : null},
        {"Id": 3, "Locaux": sets[4].isNotEmpty ? sets[4] : null, "Visiteur": sets[5].isNotEmpty ? sets[5] : null},
        {"Id": 4, "Locaux": sets[6].isNotEmpty ? sets[6] : null, "Visiteur": sets[7].isNotEmpty ? sets[7] : null},
        {"Id": 5, "Locaux": sets[8].isNotEmpty ? sets[8] : null, "Visiteur": sets[9].isNotEmpty ? sets[9] : null}
      ],
      "IsUnfinished": false,
      "Comments": "TEST_POST_API: $comment",
      "SignLocaux": "",
      "SignVisiteurs": "",
      "SenderName": senderName,
      "SenderTeam": senderTeamName,
      "SenderMail": senderEmail,
      "MatchSheetFileName": matchSheetFilename,
      "MatchSheetFileBase64": matchSheetFileBase64,
    };
    print(data);

    String url = "XXXXXXXXX/resultats/sendresult";
    Response response = await dio.post(url, data: data, options: Options(headers: {}));
    if (response.statusCode == 200 || response.statusCode == 304) {
      return SendedMatchResult.fromJson(response.data);
    } else {
      throw Exception("Impossible d'envoyer les résultats");
    }
  }
}
