import 'package:add_2_calendar/add_2_calendar.dart' as addToCalendar;
import 'package:feature_flags/feature_flags.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v34/commons/circular_menu/circular_menu.dart';
import 'package:v34/commons/feature_tour.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/orientation_helper.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/commons/timeline/details/event_place.dart';
import 'package:v34/commons/timeline/postponed_badge.dart';
import 'package:v34/features_flag.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/gymnasium_bloc.dart';
import 'package:v34/pages/match/edit_match.dart';
import 'package:v34/pages/match/match_info.dart';
import 'package:v34/pages/match/postpone_match.dart';
import 'package:v34/pages/scoreboard/scoreboard_page.dart';
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
  late final AnimationController _animationController;
  late GymnasiumBloc? _gymnasiumBloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      _closeMenu();
    });

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    _animationController.addListener(() => setState(() {}));
    _animationController.forward();

    _gymnasiumBloc = GymnasiumBloc(RepositoryProvider.of(context), GymnasiumUninitializedState());
    if (widget.event.type == EventType.Match) {
      _gymnasiumBloc!.add(LoadGymnasiumEvent(gymnasiumCode: widget.event.gymnasiumCode));
    }

    if (widget.event.type == EventType.Match) {
      Repository repository = RepositoryProvider.of<Repository>(context);
      Future.wait([
        repository.loadTeamClub(widget.event.hostCode),
        repository.loadTeam(widget.event.hostCode!),
        repository.loadTeamClub(widget.event.visitorCode),
        repository.loadTeam(widget.event.visitorCode!),
      ]).then((values) {
        setState(() {
          _hostClub = values[0] as Club;
          _hostTeam = values[1] as Team;
          _visitorClub = values[2] as Club;
          _visitorTeam = values[3] as Team;
        });
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Widget> _buildDateAndHour(BuildContext context) {
    return [
      ListTile(
          leading: Icon(
            Icons.date_range,
            color: Theme.of(context).textTheme.bodyText1!.color,
            size: _iconSize,
          ),
          title: EventDate(date: widget.event.date, endDate: widget.event.endDate, fullFormat: true)),
      ListTile(
        leading: Icon(Icons.access_time, color: Theme.of(context).textTheme.bodyText1!.color, size: _iconSize),
        title: FeatureTour(
          title: "Date et heure",
          featureId: "match_date_and_hour",
          paragraphs: [
            "Retrouvez la date et l'heure du match. Pour ajouter ce match à votre calendrier, cliquez sur le lien \"Ajouter au calendrier\""
          ],
          child: EventDate(
            date: widget.event.date,
            endDate: widget.event.endDate,
            hour: true,
            fullDay: widget.event.fullDay ?? false,
          ),
        ),
      ),
      if (widget.event.postponedDate != null)
        Padding(
          padding: const EdgeInsets.only(left: 18.0, bottom: 18, top: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostponedBadge(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 18),
                  child: BlocBuilder<GymnasiumBloc, GymnasiumState>(
                    builder: (context, state) => state is GymnasiumLoadedState
                        ? Text(
                            "Initialement prévu le ${_fullDateFormat.format(widget.event.initialDate!)} à ${widget.event.initialPlace}",
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontStyle: FontStyle.italic))
                        : Loading.small(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ListTile(
        contentPadding: EdgeInsets.only(left: 0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Theme.of(context).textTheme.bodyText1!.color,
                size: _iconSize,
              ),
              title: widget.event.type == EventType.Match
                  ? BlocBuilder<GymnasiumBloc, GymnasiumState>(
                      builder: (context, state) => (state is GymnasiumLoadedState)
                          ? Text(state.gymnasium.fullname!,
                              textAlign: TextAlign.left, style: Theme.of(context).textTheme.bodyText2)
                          : Loading.small())
                  : Text(widget.event.place ?? "", style: Theme.of(context).textTheme.bodyText2),
            ),
            if (widget.event.place != null && widget.event.type != EventType.Match)
              TextButton.icon(
                onPressed: () => MapsLauncher.launchQuery(widget.event.place!),
                icon: Icon(
                  Icons.directions,
                  size: 26,
                ),
                label: Text("Itinéraire"),
              ),
          ],
        ),
      ),
    ];
  }

  Widget _buildOrganizerClub(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset('assets/shield.svg',
          width: _iconSize, height: _iconSize, color: Theme.of(context).textTheme.bodyText1!.color!),
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
        title: HtmlWidget(
          widget.event.description!,
          textStyle: Theme.of(context).textTheme.bodyText2!,
          onTapUrl: (url) {
            launch(url);
          },
        ));
  }

  Widget _buildContact(BuildContext context) {
    final Uri params = Uri(
      scheme: 'mailto',
      path: widget.event.contactEmail,
      query: 'subject=${widget.event.name}',
    );
    Widget? subtitle;
    if (widget.event.contactPhone != null || widget.event.contactEmail != null) {
      subtitle = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.event.contactPhone != null)
            TextButton.icon(
              icon: Icon(Icons.phone, color: Theme.of(context).colorScheme.secondary),
              onPressed: () => launchURL("tel:${widget.event.contactPhone}"),
              label: Text("Appeler"),
            ),
          if (widget.event.contactEmail != null)
            TextButton.icon(
              icon: Icon(Icons.mail, color: Theme.of(context).colorScheme.secondary),
              onPressed: () => launchURL(params.toString()),
              label: Text("Envoyer un mail"),
            )
        ],
      );
    }
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.person,
            color: Theme.of(context).textTheme.bodyText1!.color,
            size: _iconSize,
          ),
          title:
              Text(widget.event.contactName!, textAlign: TextAlign.left, style: Theme.of(context).textTheme.bodyText2!),
        ),
        if (subtitle != null) subtitle,
      ],
    );
  }

  void _addEventToCalendar() async {
    final addToCalendar.Event event = addToCalendar.Event(
        title: widget.event.name!,
        location: widget.event.place!,
        startDate: widget.event.date!,
        endDate: widget.event.fullDay ?? false
            ? widget.event.date!.add(Duration(hours: 1))
            : (widget.event.endDate ?? this.widget.event.date!.add(Duration(hours: 2))),
        allDay: widget.event.fullDay ?? false);
    await addToCalendar.Add2Calendar.addEvent2Cal(event);
  }

  List<Widget> _buildTitle(BuildContext context) {
    Color color = Theme.of(context).textTheme.bodyText2!.color!;
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
          forces: widget.event.forces,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBarButton(context,
                  tag: "btn-edit",
                  icon: Icon(Icons.edit),
                  label: Text(
                    "Saisir\nle résultat",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: _hostTeam != null && _visitorTeam != null && _hostClub != null && _visitorClub != null
                      ? () {
                          _closeMenu();
                          RouterFacade.push(
                            context: context,
                            builder: (_) => EditMatch(
                              matchCode: widget.event.matchCode!,
                              hostTeam: _hostTeam!,
                              visitorTeam: _visitorTeam!,
                              hostClub: _hostClub!,
                              visitorClub: _visitorClub!,
                              matchDate: widget.event.date!,
                            ),
                          );
                        }
                      : null,
                  defaultAction: true),
              _buildBarButton(
                context,
                tag: "btn-postpone",
                icon: SvgPicture.asset("assets/calendar-postpone3.svg", width: 30, color: color),
                label: Text(
                  "Reporter\nle match",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                onPressed: _hostTeam != null && _visitorTeam != null && _hostClub != null && _visitorClub != null
                    ? () {
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
                      }
                    : null,
              ),
              if (Features.isFeatureEnabled(context, experimental_scoreboard_feature) &&
                  _hostTeam != null &&
                  _hostClub != null &&
                  _visitorTeam != null &&
                  _visitorClub != null)
                _buildBarButton(
                  context,
                  tag: "btn-play",
                  icon: Icon(Icons.play_arrow_rounded, size: 30, color: color),
                  label: Text(
                    "Scoreur",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () {
                    _closeMenu();
                    RouterFacade.push(
                      context: context,
                      builder: (_) => OrientationHelper(
                        child: ScoreBoardPage(
                          hostTeam: _hostTeam!,
                          hostClub: _hostClub!,
                          visitorTeam: _visitorTeam!,
                          visitorClub: _visitorClub!,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        if (widget.event.matchCode != null && widget.event.matchCode!.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
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
                icon: Icon(Icons.file_present, size: 30, color: Theme.of(context).colorScheme.secondary),
                label: Text(
                  "Télécharger la feuille de match",
                  textAlign: TextAlign.start,
                ),
              ),
            ],
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
        if ((widget.event.type == EventType.Tournament || widget.event.type == EventType.Meeting) &&
            (widget.event.webSite != null && widget.event.webSite!.isNotEmpty))
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBarButton(
                  context,
                  tag: "btn-website",
                  icon: Icon(Icons.public),
                  label: Text(
                    "Visitez le site web",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  onPressed: () {
                    _closeMenu();
                    launchURL(widget.event.webSite!);
                  },
                  defaultAction: true,
                ),
              ],
            ),
          ),
        _divider,
      ];
    }
  }

  Widget _buildBarButton(BuildContext context,
      {String? tag,
      required Widget icon,
      required Widget label,
      required void Function()? onPressed,
      bool defaultAction = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
              heroTag: tag,
              onPressed: onPressed,
              backgroundColor: defaultAction
                  ? (onPressed != null ? null : Theme.of(context).textTheme.bodyText1!.color!)
                  : Theme.of(context).canvasColor,
              child: icon,
              shape: defaultAction
                  ? null
                  : (onPressed != null
                      ? CircleBorder(side: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 2))
                      : CircleBorder(
                          side: BorderSide(color: Theme.of(context).textTheme.bodyText1!.color!, width: 2)))),
          SizedBox(
            height: 50 * _animationController.value,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: label,
            ),
          ),
        ],
      ),
    );
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
              child: NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    if (notification.metrics.extentBefore > 100 &&
                        _animationController.status != AnimationStatus.reverse) {
                      _animationController.reverse();
                    } else if (notification.metrics.extentBefore < 100 &&
                        _animationController.status != AnimationStatus.forward) {
                      _animationController.forward();
                    }
                  }
                  return false;
                },
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
            ),
          ],
        ),
      ),
    );
  }

  _closeMenu() {
    menuKey.currentState?.reverseAnimation();
  }
}
