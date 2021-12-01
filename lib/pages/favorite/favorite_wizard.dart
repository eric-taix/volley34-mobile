import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/rounded_outlined_button.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/favorite/favorite_club.dart';
import 'package:v34/pages/favorite/favorite_team.dart';

class SelectFavoriteTeam extends StatefulWidget {
  const SelectFavoriteTeam({Key? key}) : super(key: key);

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
    String selectionType = _pageController.hasClients && _pageController.page == 1 ? "équipe" : "club";
    return SafeArea(
      child: Container(
        color: Theme.of(context).canvasColor,
        child: Column(
          children: [
            Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text("Sélectionnez votre $selectionType", style: Theme.of(context).textTheme.headline4),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  FavoriteClubSelection(
                      onClubChange: (club) => setState(() {
                            _selectedClub = club;
                            _selectedTeam = null;
                          })),
                  if (_selectedClub != null)
                    FavoriteTeamSelection(
                        club: _selectedClub!, onTeamChange: (team) => setState(() => _selectedTeam = team)),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _selectedTeam != null && _selectedClub != null ? () => _save(context) : null,
                      child: Text("Enregistrer"),
                    ),
                    RoundedOutlinedButton(
                      onPressed: _pageController.hasClients && _pageController.page == 1 ? () => _back() : null,
                      leadingIcon: Icons.arrow_back_ios_rounded,
                      child: Text("Préc."),
                    ),
                    RoundedOutlinedButton(
                      onPressed: _selectedClub != null && _pageController.hasClients && _pageController.page == 0
                          ? () => _next()
                          : null,
                      trailingIcon: Icons.arrow_forward_ios_rounded,
                      child: Text("Suiv."),
                    ),
                    TextButton(onPressed: () => _close(context), child: Text("Annuler")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _back() async {
    if (_pageController.page == 1) {
      await _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      setState(() {});
    }
  }

  _next() async {
    if (_pageController.page == 0) {
      await _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      setState(() {});
    }
  }

  _save(BuildContext context) async {
    _preferencesBloc.add(PreferencesSaveEvent(favoriteClub: _selectedClub, favoriteTeam: _selectedTeam));
    _close(context);
  }

  _close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
