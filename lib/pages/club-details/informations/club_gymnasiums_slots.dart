import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/pages/club-details/blocs/club_slots.bloc.dart';
import 'package:v34/repositories/repository.dart';

class ClubGymnasiumsSlots extends StatefulWidget {
  final String? clubCode;

  ClubGymnasiumsSlots({this.clubCode});

  @override
  _ClubGymnasiumsSlotsState createState() => _ClubGymnasiumsSlotsState();
}

class _ClubGymnasiumsSlotsState extends State<ClubGymnasiumsSlots> {
  ClubSlotsBloc? _slotsBloc;

  @override
  void initState() {
    super.initState();
    _slotsBloc = ClubSlotsBloc(repository: RepositoryProvider.of<Repository>(context))
      ..add(ClubSlotsLoadEvent(clubCode: widget.clubCode));
  }

  @override
  void dispose() {
    super.dispose();
    _slotsBloc!.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _slotsBloc,
        builder: (context, dynamic state) {
          return TitledCard(
              icon: Icon(Icons.date_range, color: Theme.of(context).textTheme.headline6!.color),
              title: (state is ClubSlotsLoaded && state.slots!.length > 1) ? "Créneaux" : "Créneau",
              body: (state is ClubSlotsLoaded)
                  ? Column(
                      children: <Widget>[
                        ...state.slots!.map((slot) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 18.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        border: Border(
                                          left: BorderSide(
                                            width: 5,
                                            color: Colors
                                                .red, //TinyColor(Theme.of(context).cardTheme.color).lighten(3).color
                                          ),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(slot.day!, style: Theme.of(context).textTheme.headline4),
                                          Text(slot.time!.format(context), style: Theme.of(context).textTheme.headline5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(slot.name!),
                                      Text("${slot.postalCode} - ${slot.town}",
                                          style: Theme.of(context).textTheme.bodyText1),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    )
                  : Loading(),
              actions: [
                CardAction(
                  icon: Icons.map,
                )
              ]);
        });
  }
}
