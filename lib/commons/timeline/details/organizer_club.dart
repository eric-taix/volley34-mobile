import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/pages/dashboard/blocs/club_bloc.dart';

class OrganizerClub extends StatefulWidget {
  final String? clubCode;

  const OrganizerClub({Key? key, required this.clubCode}) : super(key: key);

  @override
  OrganizerClubState createState() => OrganizerClubState();
}

class OrganizerClubState extends State<OrganizerClub> {
  ClubBloc? _clubBloc;

  @override
  void initState() {
    super.initState();
    _clubBloc = ClubBloc(ClubUninitializedState(), repository: RepositoryProvider.of(context));
    _clubBloc!.add(LoadClubEvent(clubCode: widget.clubCode));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _clubBloc,
      builder: (context, dynamic state) {
        if (state is ClubLoadedState) {
          return Text(state.club.name!,
              textAlign: TextAlign.left,
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).textTheme.bodyText2!.color));
        } else {
          return Loading();
        }
      },
    );
  }
}
