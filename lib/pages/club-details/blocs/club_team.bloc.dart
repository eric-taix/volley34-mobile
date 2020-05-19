
//---- STATE
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/repositories/repository.dart';


class SlidingResult {
  List<int> points;
}

@immutable
abstract class TeamState {}

class TeamStateUninitialized extends TeamState {}
class TeamSlidingStatsLoading extends TeamState {}
class TeamSlidingStatsLoaded extends TeamState {
  final List<double> results;
  TeamSlidingStatsLoaded({this.results});
}

//---- EVENT
@immutable
abstract class TeamEvent {}
class TeamLoadSlidingResult extends TeamEvent {
  final String code;
  final int last;
  TeamLoadSlidingResult({this.code, this.last});
}
class TeamLoadAverageSlidingResult extends TeamEvent {
  final String code;
  final int last;
  final int count;
  TeamLoadAverageSlidingResult({this.code, this.last, this.count});
}

//---- BLOC
class TeamBloc extends Bloc<TeamEvent, TeamState> {

  final Repository repository;

  TeamBloc({this.repository});

  @override
  TeamState get initialState => TeamStateUninitialized();

  @override
  Stream<TeamState> mapEventToState(TeamEvent event) async* {
    if (event is TeamLoadSlidingResult) {
      yield TeamSlidingStatsLoading();
      var sets = await _retrieveLinearResult(event.code, event.last);
      yield TeamSlidingStatsLoaded(results: sets);
    }

    if (event is TeamLoadAverageSlidingResult) {
      yield TeamSlidingStatsLoading();
      var results = await _retrieveLinearResult(event.code, event.last);
      var sets = List.generate(event.count, (index) {
        double sum = 0;
        for(int i = index * event.count; i < (index + 1) * event.count; i++) {
          sum += results[i];
        }
        return sum / event.count;
      }).toList();
      yield TeamSlidingStatsLoaded(results: sets);
    }
  }

  Future<List<double>> _retrieveLinearResult(String code, int last) async {
    var results = await repository.loadTeamLastMatchesResult(code, last);
    var setsDiff = results.map((result) {
      bool isHost = result.hostTeamCode == code;
      return (result.totalSetsHost - result.totalSetsVisitor) * (isHost ? 1 : -1);
    }).toList();
    for(int i = 0; i < setsDiff.length - 1; i++) {
      setsDiff[i+1] += setsDiff[i];
    }
    return setsDiff.map((d) => d.toDouble()).toList();
  }
  
}
