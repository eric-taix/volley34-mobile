import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/theme.dart';

class FavoriteTeamSelection extends StatefulWidget {
  final Club club;

  final Function(Team) onTeamChange;

  const FavoriteTeamSelection({Key? key, required this.club, required this.onTeamChange}) : super(key: key);

  @override
  State<FavoriteTeamSelection> createState() => _FavoriteTeamSelectionState();
}

class _FavoriteTeamSelectionState extends State<FavoriteTeamSelection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  late Repository _repository;
  Team? _favoriteTeam;
  int? _selectedIndex;
  List<Team> _teams = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository = RepositoryProvider.of<Repository>(context);
    _repository
        .loadClubTeams(widget.club.code)
        .then((teams) => _teams = teams..sort((t1, t2) => t1.name!.toLowerCase().compareTo(t2.name!.toLowerCase())))
        .then(
      (_) {
        if (mounted) {
          setState(
            () {},
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      itemScrollController: itemScrollController,
      itemCount: _teams.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: _selectedIndex == index
              ? TinyColor(Theme.of(context).cardTheme.color!).mix(input: Colors.white, amount: 20).color
              : null,
          margin: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
            onTap: () => _selectTeam(index),
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, bottom: 18, left: 18, right: 18),
              child: Text(_teams[index].name!),
            ),
          ),
        );
      },
    );
  }

  void _selectTeam(int index) {
    widget.onTeamChange(_teams[index]);
    setState(() => _selectedIndex = index);
  }
}
