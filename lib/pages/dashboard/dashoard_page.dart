import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:v34/pages/dashboard/blocs/club_stats.dart';
import 'package:v34/pages/dashboard/blocs/club_teams.dart';
import 'package:v34/pages/dashboard/blocs/favorite_bloc.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/dashboard/fav_club_card.dart';
import 'package:v34/repositories/repository.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  FavoriteBloc _favoriteBloc;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = FavoriteBloc(repository: RepositoryProvider.of<Repository>(context))..add(FavoriteLoadEvent());
    _pageController = PageController(initialPage: 0, viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 55),
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
          bloc: _favoriteBloc,
          builder: (context, state) {
            return (state is FavoriteLoadedState)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return _buildDashboardItem(
                        index,
                        state,
                      );
                    },
                  )
                : SizedBox();
          }),
    );
  }

  Widget _buildDashboardItem(int index, FavoriteState state) {
    switch (index) {
      case 0:
        return Paragraph(title: state.teamCodes.length > 1 ? "Vos équipes" : "Votre équipe");
      case 1:
        return Container(height: 120);
      case 2:
        return Paragraph(title: state.clubs.length > 1 ? "Vos clubs" : "Votre club");
      case 3:
        return (state is FavoriteLoadedState)
            ? Container(
                height: 200,
                child: AnimationLimiter(
                  child: PageView.builder(
                    itemCount: state.clubs.length,
                    controller: _pageController,
                    itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        horizontalOffset: 250.0,
                        child: FavoriteClubCard(state.clubs[index]),
                      ),
                    ),
                  ),
                ))
            : Container(
                constraints: BoxConstraints(minHeight: 100),
                child: Center(child: CircularProgressIndicator()),
              );
      case 4:
        return Paragraph(title: "Votre agenda");
      case 5:
        return Container(
          height: 200,
          child: SizedBox(),
        );
    }
  }
}
