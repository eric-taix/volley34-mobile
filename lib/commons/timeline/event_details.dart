import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/commons/timeline/details/event_info.dart';
import 'package:v34/models/event.dart';
import 'package:v34/repositories/repository.dart';

class EventDetails extends StatefulWidget {
  final Event event;

  const EventDetails({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String? hostLogoUrl = "";
  String? visitorLogoUrl = "";

  @override
  void initState() {
    super.initState();
    if (widget.event.type == EventType.Match) {
      Repository repository = RepositoryProvider.of<Repository>(context);
      repository.loadTeamClub(widget.event.hostCode).then((hostClub) {
        hostLogoUrl = hostClub.logoUrl;
        return repository.loadTeamClub(widget.event.visitorCode);
      }).then((visitorClub) {
        visitorLogoUrl = visitorClub.logoUrl;
        setState(() {});
      });
    }
  }

  Widget _screenTitle(BuildContext context) {
    if (widget.event.type == EventType.Match) {
      return Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 8.0),
        child: RichText(
          textScaleFactor: 0.7,
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "",
            children: [
              TextSpan(text: widget.event.hostName, style: Theme.of(context).appBarTheme.titleTextStyle),
              TextSpan(text: "  reçoit  ", style: Theme.of(context).textTheme.bodyText1),
              TextSpan(text: widget.event.visitorName, style: Theme.of(context).appBarTheme.titleTextStyle),
            ],
          ),
        ),
      );
    } else {
      return Text(widget.event.name!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: 16.0,
          ));
    }
  }

  Widget _buildAppBarBackground(BuildContext context) {
    if (widget.event.type == EventType.Match) {
      return Stack(
        children: [
          Positioned(
            top: 60,
            left: 50,
            child: RoundedNetworkImage(
              80,
              hostLogoUrl,
            ),
          ),
          Positioned(
            top: 60,
            right: 50,
            child: RoundedNetworkImage(
              80,
              visitorLogoUrl,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, 0.5),
                end: Alignment(0.0, 0.0),
                colors: <Color>[
                  Color(0x60000000),
                  Color(0x00000000),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (widget.event.imageUrl != null && widget.event.imageUrl != "") {
      return Image.network(widget.event.imageUrl!, fit: BoxFit.cover);
    } else {
      return Container(color: Theme.of(context).appBarTheme.backgroundColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                stretch: true,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: true,
                  title: _screenTitle(context),
                  background: _buildAppBarBackground(context),
                ),
              ),
            ];
          },
          body: EventInfo(event: widget.event),
        ),
      ),
    );
  }
}
