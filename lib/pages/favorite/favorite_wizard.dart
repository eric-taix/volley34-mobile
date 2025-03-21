import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/favorite/favorite_club.dart';
import 'package:v34/pages/favorite/favorite_team.dart';

class SelectFavoriteTeam extends StatefulWidget {
  final bool canClose;

  const SelectFavoriteTeam({Key? key, required this.canClose}) : super(key: key);

  @override
  State<SelectFavoriteTeam> createState() => _SelectFavoriteTeamState();
}

class _SelectFavoriteTeamState extends State<SelectFavoriteTeam> {
  Team? _selectedTeam;
  Club? _selectedClub;

  late final PageController _pageController;
  late final PreferencesBloc _preferencesBloc;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _preferencesBloc = BlocProvider.of<PreferencesBloc>(context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String selectionType = _selectedClub != null ? "équipe" : "club";
    return BlocListener<PreferencesBloc, PreferencesState>(
      listener: (context, state) {
        if (state is PreferencesUpdatedState) {
          if (state.favoriteTeam != null && state.favoriteClub != null) {
            Future.delayed(Duration(milliseconds: 100), () => _close(context));
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: AppBar(
            leading: widget.canClose
                ? IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pop())
                : SizedBox(),
            title: Text("Sélectionnez votre $selectionType", style: Theme.of(context).textTheme.headlineMedium),
          ),
          body: Container(
            color: Theme.of(context).canvasColor,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      FavoriteClubSelection(
                        onClubChange: (club) => setState(
                          () {
                            _selectedClub = club;
                            _selectedTeam = null;
                            _pageController.animateToPage(1,
                                duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                          },
                        ),
                      ),
                      if (_selectedClub != null)
                        FavoriteTeamSelection(
                          club: _selectedClub!,
                          onTeamChange: (team) => setState(() {
                            _selectedTeam = team;
                            if (_selectedTeam != null && _selectedClub != null) {
                              _save(context);
                            }
                          }),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _save(BuildContext context) async {
    _preferencesBloc.add(PreferencesSaveEvent(favoriteClub: _selectedClub, favoriteTeam: _selectedTeam));
//    _close(context);
  }

  _close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
