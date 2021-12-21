import 'package:add_2_calendar/add_2_calendar.dart' as addToCalendar;
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/circular_menu/circular_menu.dart';
import 'package:v34/commons/circular_menu/circular_menu_item.dart';
import 'package:v34/commons/feature_tour.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/commons/timeline/details/event_place.dart';
import 'package:v34/commons/timeline/postponed_badge.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/gymnasium_bloc.dart';
import 'package:v34/pages/match/edit_match.dart';
import 'package:v34/pages/match/match_info.dart';
import 'package:v34/pages/match/postpone_match.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/launch.dart';

import 'event_date.dart';
import 'organizer_club.dart';

class EventInfo extends StatefulWidget {
  final Event event;
  const EventInfo({Key? key, required this.event}) : super(key: key);

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> with SingleTickerProviderStateMixin {
  static final Divider _divider = Divider(indent: 20, endIndent: 20);

  Team? _hostTeam;
  Club? _hostClub;
  Team? _visitorTeam;
  Club? _visitorClub;

  final DateFormat _fullDateFormat = DateFormat('EEEE dd MMMM yyyy', "FR");

  final double _iconSize = 30.0;

  GlobalKey<CircularMenuState> menuKey = GlobalKey<CircularMenuState>();
  late final ScrollController _scrollController;

  late GymnasiumBloc? _gymnasiumBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _closeMenu();
    });
    if (widget.event.type == EventType.Match) {
      Repository repository = RepositoryProvider.of<Repository>(context);
      repository.loadTeamClub(widget.event.hostCode).then((hostClub) {
        _hostClub = hostClub;
        return repository.loadTeam(widget.event.hostCode!);
      }).then((hostTeam) {
        _hostTeam = hostTeam;
        return repository.loadTeamClub(widget.event.visitorCode);
      }).then((visitorClub) {
        _visitorClub = visitorClub;
        return repository.loadTeam(widget.event.visitorCode!);
      }).then((visitorTeam) {
        _visitorTeam = visitorTeam;
        setState(() {});
        Future.delayed(Duration(seconds: 1)).then((_) {
          FeatureDiscovery.discoverFeatures(
            context,
            [
              ...[
                "match_opponents",
                "match_date_and_hour",
                "match_place",
                "match_actions",
              ],
            ],
          );
        });
      });
    }

    if (widget.event.type == EventType.Match) {
      _gymnasiumBloc = GymnasiumBloc(RepositoryProvider.of(context), GymnasiumUninitializedState());
      _gymnasiumBloc!.add(LoadGymnasiumEvent(gymnasiumCode: widget.event.gymnasiumCode));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildDateAndHour(BuildContext context) {
    return [
      Stack(
        children: [
          ListTile(
              leading: Icon(
                Icons.date_range,
                color: Theme.of(context).textTheme.bodyText1!.color,
                size: _iconSize,
              ),
              title: EventDate(date: widget.event.date, endDate: widget.event.endDate, fullFormat: true)),
          Positioned(top: 10, right: 24, child: PostponedBadge()),
        ],
      ),
      ListTile(
          leading: Icon(Icons.access_time, color: Theme.of(context).textTheme.bodyText1!.color, size: _iconSize),
          title: FeatureTour(
              title: "Date et heure",
              featureId: "match_date_and_hour",
              paragraphs: [
                "Retrouvez la date et l'heure du match. Pour ajouter ce match à votre calendrier, cliquez sur le lien \"Ajouter au calendrier\""
              ],
              child: EventDate(date: widget.event.date, endDate: widget.event.endDate, hour: true))),
      if (widget.event.postponedDate != null)
        Padding(
          padding: const EdgeInsets.only(left: 18.0, bottom: 18, top: 8),
          child: Text("Initialement prévu le ${_fullDateFormat.format(widget.event.initialDate!)}",
              style: Theme.of(context).textTheme.bodyText1),
        ),
      ListTile(
        contentPadding: EdgeInsets.only(left: 6),
        title: Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _addEventToCalendar(),
            icon: Icon(
              Icons.calendar_today,
            ),
            label: Text("Ajouter à l'agenda"),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPlace(BuildContext context) {
    return [
      FeatureTour(
        title: "Localisation",
        featureId: "match_place",
        paragraphs: [
          "Localisez l'emplacement du match sur la carte. En cliquant sur le lien \"Itinéraire\" : votre application de navigation vous guidera à votre destination.",
        ],
        child: BlocBuilder<GymnasiumBloc, GymnasiumState>(
          builder: (context, state) {
            return state is GymnasiumLoadedState
                ? ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      size: _iconSize,
                    ),
                    title: Text(state.gymnasium.fullname!,
                        textAlign: TextAlign.left, style: Theme.of(context).textTheme.bodyText2),
                  )
                : Loading();
          },
        ),
      )
    ];
  }

  Widget _buildOrganizerClub(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset('assets/shield.svg',
          width: _iconSize, height: _iconSize, color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5)),
      title: OrganizerClub(clubCode: widget.event.clubCode),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.description,
          color: Theme.of(context).textTheme.bodyText1!.color!,
          size: _iconSize,
        ),
        title: HtmlWidget(widget.event.description!, textStyle: Theme.of(context).textTheme.bodyText2!));
  }

  Widget _buildContact(BuildContext context) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: widget.event.contactEmail,
      query: 'subject=${widget.event.name}',
    );
    Widget? subtitle;
    if (widget.event.contactPhone != null || widget.event.contactEmail != null) {
      subtitle = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (widget.event.contactPhone != null)
              ElevatedButton.icon(
                icon: Icon(Icons.phone, color: Theme.of(context).textTheme.bodyText1!.color),
                onPressed: () => launchURL("tel:${widget.event.contactPhone}"),
                label: Text("Appeler"),
              ),
            if (widget.event.contactEmail != null)
              ElevatedButton.icon(
                icon: Icon(Icons.mail, color: Theme.of(context).textTheme.bodyText1!.color),
                onPressed: () => launchURL(params.toString()),
                label: Text("Envoyer un mail"),
              )
          ],
        ),
      );
    }
    return ListTile(
      leading: Icon(
        Icons.person,
        color: Theme.of(context).textTheme.bodyText1!.color,
        size: _iconSize,
      ),
      title: Text(widget.event.contactName!, textAlign: TextAlign.left, style: Theme.of(context).textTheme.bodyText2!),
      subtitle: subtitle,
    );
  }

  void _addEventToCalendar() async {
    final addToCalendar.Event event = addToCalendar.Event(
        title: this.widget.event.name!,
        location: this.widget.event.place!,
        startDate: this.widget.event.date!,
        endDate: this.widget.event.endDate ?? this.widget.event.date!.add(Duration(hours: 2)));
    await addToCalendar.Add2Calendar.addEvent2Cal(event);
  }

  List<Widget> _buildTitle(BuildContext context) {
    if (widget.event.type == EventType.Match) {
      return [
        MatchInfo(
          hostTeam: _hostTeam,
          visitorTeam: _visitorTeam,
          hostClub: _hostClub,
          visitorClub: _visitorClub,
          date: widget.event.date,
          showMatchDate: false,
          showTeamLink: true,
        ),
        _divider,
      ];
    } else if (widget.event.type == EventType.Unknown) {
      return [];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 38.0, horizontal: 8),
          child: ListTile(
            title: Text(
              widget.event.name!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        _divider,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _closeMenu(),
      child: BlocProvider<GymnasiumBloc>(
        create: (context) => _gymnasiumBloc!,
        child: Stack(
          children: [
            Container(
              child: ListView(
                controller: _scrollController,
                children: [
                  ..._buildTitle(context),
                  ..._buildDateAndHour(context),
                  _divider,
                  ..._buildPlace(context),
                  EventPlace(
                    event: widget.event,
                    onCameraMoveStarted: () => _closeMenu(),
                  ),
                  if (widget.event.clubCode != null && widget.event.clubCode!.isNotEmpty) ...[
                    _divider,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _buildOrganizerClub(context),
                    ),
                  ],
                  if (widget.event.description != null && widget.event.description!.isNotEmpty) ...[
                    _divider,
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _buildDescription(context),
                    ),
                  ],
                  if (widget.event.contactName != null && widget.event.contactName!.isNotEmpty) ...[
                    _divider,
                    Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), child: _buildContact(context)),
                  ],
                ],
              ),
            ),
            if (widget.event.type == EventType.Match)
              CircularMenu(
                key: menuKey,
                alignment: Alignment.bottomRight,
                radius: 120,
                toggleButtonColor: Theme.of(context).colorScheme.secondary,
                toggleButtonMargin: 18,
                items: [
                  /*
                  Icon(
                      icon,
                      size: iconSize,
                      color: iconColor ?? Colors.white,
                    )
                  */
                  CircularMenuItem(
                    icon: Icon(Icons.play_arrow, size: 30, color: Theme.of(context).textTheme.bodyText2!.color),
                  ),
                  CircularMenuItem(
                    icon: Icon(Icons.edit, size: 30, color: Theme.of(context).textTheme.bodyText2!.color),
                    onTap: () {
                      _closeMenu();
                      RouterFacade.push(
                        context: context,
                        builder: (_) => EditMatch(
                          hostTeam: _hostTeam!,
                          visitorTeam: _visitorTeam!,
                          hostClub: _hostClub!,
                          visitorClub: _visitorClub!,
                          matchDate: widget.event.date!,
                        ),
                      );
                    },
                  ),
                  CircularMenuItem(
                    icon: Icon(Icons.timer, size: 30, color: Theme.of(context).textTheme.bodyText2!.color),
                    onTap: () {
                      _closeMenu();
                      RouterFacade.push(
                        context: context,
                        builder: (_) => PostPoneMatch(
                          hostTeam: _hostTeam!,
                          visitorTeam: _visitorTeam!,
                          hostClub: _hostClub!,
                          visitorClub: _visitorClub!,
                          matchDate: widget.event.date!,
                        ),
                      );
                    },
                  ),
                  if (widget.event.matchCode != null && widget.event.matchCode!.isNotEmpty)
                    CircularMenuItem(
                      icon: Icon(Icons.file_present, size: 30, color: Theme.of(context).textTheme.bodyText2!.color),
                      onTap: () {
                        FirebaseAnalytics.instance.logEvent(
                          name: "file_download",
                          parameters: filterOutNulls(<String, String?>{
                            "file_name": "FDM_${widget.event.matchCode!}",
                            "file_extension": "pdf",
                          }),
                        );
                        _closeMenu();
                        launchURL("https://www.volley34.fr/Data/FDM/FDM_${widget.event.matchCode!}.pdf");
                      },
                    ),
                ],
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: FeatureTour(
                title: "Actions",
                featureId: "match_actions",
                paragraphsChildren: [
                  Text("Ouvrez le menu pour découvrir les actions possibles :",
                      style: Theme.of(context).textTheme.bodyText2, textScaleFactor: 1.2),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RichText(
                      textScaleFactor: 1.2,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.play_arrow)),
                          TextSpan(text: " Démarrez le match (prochainement)"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RichText(
                      textScaleFactor: 1.2,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(Icons.edit),
                          ),
                          TextSpan(text: " Saisissez le score"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RichText(
                      textScaleFactor: 1.2,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.timer)),
                          TextSpan(text: " Reportez le match"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: RichText(
                      textScaleFactor: 1.2,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          WidgetSpan(alignment: PlaceholderAlignment.middle, child: Icon(Icons.file_present)),
                          TextSpan(text: " Téléchargez la feuille de match"),
                        ],
                      ),
                    ),
                  ),
                ],
                target: Icon(Icons.menu, color: Theme.of(context).cardTheme.color),
                child: Padding(
                  padding: const EdgeInsets.only(right: 88.0, bottom: 88),
                  child: SizedBox(),
                ),
                onComplete: () {
                  menuKey.currentState?.forwardAnimation();
                  return Future.value(true);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _closeMenu() {
    menuKey.currentState?.reverseAnimation();
  }
}
