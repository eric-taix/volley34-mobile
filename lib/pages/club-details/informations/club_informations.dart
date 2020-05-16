import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/commons/card/card.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/blocs/club_slots.dart';
import 'package:v34/pages/club-details/informations/club_contact.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/launch.dart';

class ClubInformations extends StatefulWidget {
  final Club club;

  ClubInformations(this.club);

  @override
  _ClubInformationsState createState() => _ClubInformationsState();
}

class _ClubInformationsState extends State<ClubInformations> {
  ClubSlotsBloc _slotsBloc;

  @override
  void initState() {
    super.initState();
    _slotsBloc = ClubSlotsBloc(repository: RepositoryProvider.of<Repository>(context))..add(ClubSlotsLoadEvent(clubCode: widget.club.code));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClubContact(club: widget.club),
        BlocBuilder(
          bloc: _slotsBloc,
          builder: (context, state) {
            return TitledCard(
                icon: Icon(FontAwesomeIcons.hotel, size: 14, color: Theme.of(context).textTheme.headline6.color),
                title: (state is ClubSlotsLoaded && state.slots.length > 1) ? "Créneaux" : "Créneau",
                body: (state is ClubSlotsLoaded)
                    ? Column(
                        children: <Widget>[
                          ...state.slots.map((slot) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 18.0),
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                                      child: Column(
                                        children: <Widget>[
                                          Text(slot.day, style: Theme.of(context).textTheme.headline4),
                                          Text(slot.time.format(context), style: Theme.of(context).textTheme.headline5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(slot.name),
                                        Text("${slot.postalCode} - ${slot.town}", style: Theme.of(context).textTheme.bodyText1),
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
                icon: FontAwesomeIcons.mapMarkedAlt,
              )
            ]);
          },
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final url;

  Tile({this.leadingIcon, this.title, this.url});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: url != null ? () => launchURL(url) : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: leadingIcon,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(title.trim(), overflow: TextOverflow.ellipsis, style: textTheme.bodyText2.copyWith()),
            ),
          ),
          if (url != null) FaIcon(FontAwesomeIcons.externalLinkAlt, size: 14, color: Theme.of(context).textTheme.bodyText2.color)
        ]),
      ),
    );
  }
}
