import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/repositories/repository.dart';

class GymnasiumSlot {
  final String name;
  final String day;
  final TimeOfDay time;
  final String town;
  final String postalCode;
  final String address;

  GymnasiumSlot(
      {this.name,
      this.day,
      this.time,
      this.town,
      this.postalCode,
      this.address});
}

//----- STATE
@immutable
abstract class ClubSlotsState extends Equatable {}

class ClubSlotUninitialized extends ClubSlotsState {
  @override
  List<Object> get props => [];
}

class ClubSlotsLoading extends ClubSlotsState {
  @override
  List<Object> get props => [];
}

class ClubSlotsLoaded extends ClubSlotsState {
  final List<GymnasiumSlot> slots;

  ClubSlotsLoaded({this.slots});

  @override
  List<Object> get props => [slots];
}

//----- EVENT

@immutable
abstract class ClubSlotsEvent extends Equatable {}

class ClubSlotsLoadEvent extends ClubSlotsEvent {
  final String clubCode;

  ClubSlotsLoadEvent({this.clubCode});

  @override
  List<Object> get props => [clubCode];
}

//---- BLOC
class ClubSlotsBloc extends Bloc<ClubSlotsEvent, ClubSlotsState> {
  final Repository repository;

  ClubSlotsBloc({this.repository}) : super(ClubSlotUninitialized());

  @override
  Stream<ClubSlotsState> mapEventToState(ClubSlotsEvent event) async* {
    if (event is ClubSlotsLoadEvent) {
      yield ClubSlotsLoading();
      var slots = await repository.loadClubSlots(event.clubCode);
      var gymnasiums = await repository.loadAllGymnasiums();
      final seen = Set<String>();
      slots.sort((slot1, slot2) => slot1.dayOfWeek.compareTo(slot2.dayOfWeek));
      var gyms = slots
          .where((slot) => seen
              .add("${slot.gymnasiumCode}-${slot.dayOfWeek}-${slot.startTime}"))
          .map((slot) {
        var gymnasium = gymnasiums.firstWhere(
            (gymnasium) => gymnasium.gymnasiumCode == slot.gymnasiumCode);
        String day;
        switch (slot.dayOfWeek) {
          case 0:
            day = "Dim.";
            break;
          case 1:
            day = "Lun.";
            break;
          case 2:
            day = "Mar.";
            break;
          case 3:
            day = "Mer.";
            break;
          case 4:
            day = "Jeu.";
            break;
          case 5:
            day = "Ven.";
            break;
          case 6:
            day = "Sam.";
            break;
        }
        return GymnasiumSlot(
            name: gymnasium.name,
            day: day,
            time: slot.startTime,
            town: gymnasium.town,
            postalCode: gymnasium.postalCode,
            address: gymnasium.address);
      }).toList();
      yield ClubSlotsLoaded(slots: gyms);
    }
  }
}
