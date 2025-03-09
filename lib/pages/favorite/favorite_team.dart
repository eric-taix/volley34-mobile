import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:v34/commons/loading.dart';
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
  List<Team>? _teams;

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
    var teams = _teams;
    return teams != null
        ? ScrollablePositionedList.builder(
            itemScrollController: itemScrollController,
            itemCount: teams.length,
            itemBuilder: (BuildContext context, int index) {
              return Material(
                child: InkWell(
                  onTap: () => _selectTeam(index),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 18, right: 18),
                            child: Text(teams[index].name!),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Center(child: Loading());
  }

  void _selectTeam(int index) {
    if (_teams != null) {
      widget.onTeamChange(_teams![index]);
    }
  }
}
