part of 'club_info_cubit.dart';

@immutable
abstract class ClubInfoState {}

class ClubInfoInitial extends ClubInfoState {}

class ClubInfoLoading extends ClubInfoInitial {}

class ClubInfoLoaded extends ClubInfoInitial {
  final int teamCount;
  ClubInfoLoaded({required this.teamCount});
}
