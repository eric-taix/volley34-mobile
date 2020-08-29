import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:search_page/search_page.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club/club_card.dart';
import 'package:v34/repositories/repository.dart';

class ClubPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> with SingleTickerProviderStateMixin {
  Repository _repository;

  List<Club> _clubs;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _loadClubs();
  }

  @override
  void didUpdateWidget(ClubPage oldWidget) async {
    _loadClubs();
    super.didUpdateWidget(oldWidget);
  }

  void _loadClubs() {
    setState(() {
      _loading = true;
    });
    _repository.loadAllClubs().then((clubs) {
      _repository.loadFavoriteClubCodes().then((favorites) {
        setState(() {
          _loading = false;
          clubs.sort((c1, c2) {
            if (favorites.contains(c1.code) && !favorites.contains(c2.code)) return -1;
            if (!favorites.contains(c1.code) && favorites.contains(c2.code)) return 1;
            return c1.shortName.toUpperCase().compareTo(c2.shortName.toUpperCase());
          });
          _clubs = clubs;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: "Clubs",
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => showSearch(
            context: context,
            delegate: SearchPage<Club>(
              items: _clubs,
              showItemsOnEmpty: true,
              searchLabel: "Rechercher un club",
              failure: Center(
                child: Text("Aucun club trouvé !"),
              ),
              filter: (club) => [
                club.name,
                club.shortName,
                club.code,
              ],
              builder: (club) => ClubCard(club, 1),
              barTheme: Theme.of(context).copyWith(
                textTheme: TextTheme(
                  headline6: Theme.of(context).textTheme.headline4
                ),
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: Theme.of(context).textTheme.headline5
                ),
              ),
            ),
          ),
        ),
      ],
      sliver: _loading
          ? SliverToBoxAdapter(child: Center(child: Loading()))
          : AnimationLimiter(
              child: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return index < _clubs.length
                        ? AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: ClubCard(_clubs[index], index),
                              ),
                            ),
                          )
                        : SizedBox(height: 86);
                  },
                  childCount: _clubs.length + 1,
                ),
              ),
            ),
    );
  }
}
