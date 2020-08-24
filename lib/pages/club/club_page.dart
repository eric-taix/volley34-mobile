import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:search_page/search_page.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/map/map_view.dart';
import 'package:v34/commons/no_data.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club/club_card.dart';
import 'package:v34/repositories/repository.dart';
import 'package:latlong/latlong.dart';

class ClubPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage>
    with SingleTickerProviderStateMixin {
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
            if (favorites.contains(c1.code) && !favorites.contains(c2.code))
              return -1;
            if (!favorites.contains(c1.code) && favorites.contains(c2.code))
              return 1;
            return c1.shortName
                .toUpperCase()
                .compareTo(c2.shortName.toUpperCase());
          });
          _clubs = clubs;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<TextTab> tabs = _buildTabs(context);
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
            ),
          ),
        ),
      ],
      sliver: _loading
          ? SliverFillRemaining(child: Center(child: Loading()))
          : SliverFillRemaining(
              fillOverscroll: true,
              hasScrollBody: false,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight - 10),
                    child: TextTabBar(
                      tabs: tabs,
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      ...tabs.map((tab) => tab.child).toList(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<TextTab> _buildTabs(BuildContext context) {
    return [
      TextTab("Liste", _buildList()),
      TextTab("Carte", _buildMap(context)),
    ];
  }

  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return index < (_clubs?.length ?? 0)
            ? ClubCard(_clubs[index], index)
            : SizedBox(height: 86);
      },
      itemCount: (_clubs?.length ?? 0) + 1,
    );
  }

  Widget _buildMap(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        child: Stack(children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 186.0),
            child: MapView(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 26),
              height: 200,
              child: PageView.builder(
                itemBuilder: (context, index) {
                  return SizedBox.shrink(child: ClubCard(_clubs[index], index));
                },
                itemCount: _clubs.length,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
