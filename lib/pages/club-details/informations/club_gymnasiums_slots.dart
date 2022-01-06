import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/pages/club-details/blocs/club_slots.bloc.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/launch.dart';

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
        return Column(
          children: [
            Paragraph(
              title: (state is ClubSlotsLoaded && state.slots!.length > 1) ? "Créneaux" : "Créneau",
              topPadding: 60,
            ),
            if (state is ClubSlotsLoaded)
              ...state.slots!.map(
                (slot) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 28.0, right: 4.0, bottom: 8.0, left: 18.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryVariant,
                                border: Border(
                                  left: BorderSide(
                                    width: 5,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 12, bottom: 12),
                              child: Column(
                                children: <Widget>[
                                  Text(slot.day!, style: Theme.of(context).textTheme.subtitle1),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(slot.time!.format(context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(fontSize: 12, fontWeight: FontWeight.normal)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(slot.gymnasium.name!),
                              Text("${slot.gymnasium.postalCode} - ${slot.gymnasium.town}",
                                  style: Theme.of(context).textTheme.bodyText1),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.directions),
                          onPressed: () => launchRoute(context, slot.gymnasium, route: false),
                          label: Text("Itinéraire"),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
