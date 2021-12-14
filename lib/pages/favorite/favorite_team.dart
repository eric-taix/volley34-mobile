import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

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
        return Row(
          children: [
            Radio<Team>(
              groupValue: _selectedIndex != null ? _teams[_selectedIndex!] : null,
              value: _teams[index],
              onChanged: (Team? team) => _selectTeam(index),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0, bottom: 18, left: 18, right: 18),
              child: Text(_teams[index].name!),
            ),
          ],
        );
      },
    );
  }

  void _selectTeam(int index) {
    widget.onTeamChange(_teams[index]);
    setState(() => _selectedIndex = index);
  }
}
