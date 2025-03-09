import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/search_page.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club/club_card.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/analytics.dart';

class ClubPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  late Repository _repository;

  late List<Club> _clubs;
  bool _loading = false;
  bool _error = true;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _loadClubs(context);
  }

  @override
  void didUpdateWidget(ClubPage oldWidget) async {
    _loadClubs(context);
    super.didUpdateWidget(oldWidget);
  }

  void _loadClubs(BuildContext context) {
    setState(() {
      _loading = true;
      _error = false;
    });
    _repository.loadAllClubs().then((clubs) {
      setState(() {
        _loading = false;
        clubs.sort((c1, c2) {
          return c1.shortName!.toUpperCase().compareTo(c2.shortName!.toUpperCase());
        });
        _clubs = clubs;
      });
    }).onError((error, stackTrace) {
      setState(() {
        _error = true;
        _clubs = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(title: "Clubs", actions: [
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
            builder: (club) => ClubCard(club, 1, key: ValueKey(club.code)),
            barTheme: Theme.of(context).copyWith(
              textTheme: TextTheme(titleLarge: Theme.of(context).textTheme.headlineMedium),
              inputDecorationTheme: InputDecorationTheme(hintStyle: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
        ),
      ),
    ], slivers: [
      _error
          ? SliverToBoxAdapter()
          : _loading
              ? SliverFillRemaining(child: Center(child: Loading()))
              : AnimationLimiter(
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return index > 0 && index < _clubs.length + 1
                            ? AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child:
                                          ClubCard(_clubs[index - 1], index - 1, key: ValueKey(_clubs[index - 1].code)),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(height: index == 0 ? 38 : 86);
                      },
                      childCount: _clubs.length + 2,
                    ),
                  ),
                ),
    ]);
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.clubs;
}
