import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/club_detail_page.dart';
import 'package:v34/pages/dashboard/blocs/favorite_bloc.dart';
import 'package:v34/pages/dashboard/widgets/fav_club_card.dart';
import 'package:v34/repositories/repository.dart';

class DashboardClubs extends StatefulWidget {
  final double cardHeight = 250;
  final Function(Club) onClubChange;

  const DashboardClubs({Key key, this.onClubChange}) : super(key: key);

  @override
  DashboardClubsState createState() => DashboardClubsState();
}

class DashboardClubsState extends State<DashboardClubs> {
  FavoriteBloc _favoriteBloc;
  PageController _pageController;
  double currentFavoriteClubPage = 0;

  @override
  void initState() {
    super.initState();
    _favoriteBloc = FavoriteBloc(repository: RepositoryProvider.of<Repository>(context));
    _favoriteBloc.add(FavoriteLoadEvent());
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      if (currentFavoriteClubPage != _pageController.page) {
        setState(() => currentFavoriteClubPage = _pageController.page);
      }
    });
    _favoriteBloc.listen((state) {
      if (state is FavoriteLoadedState && state.clubs.length > 0) {
        widget.onClubChange(state.clubs[0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      bloc: _favoriteBloc,
      builder: (context, state) {
        if (state is FavoriteLoadedState) {
          return Column(
            children: <Widget>[
              Container(
                height: widget.cardHeight,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: state.clubs.length,
                  controller: _pageController,
                  onPageChanged: (pageIndex) => widget.onClubChange(state.clubs[pageIndex]),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 0),
                    child: _buildFavoriteClubCard(state, index, currentFavoriteClubPage - index),
                  ),
                ),
              ),
              if (state.clubs.length > 1)
                SmoothPageIndicator(
                  controller: _pageController,
                  count: state.clubs.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    dotColor: Theme.of(context).cardTheme.color,
                    activeDotColor: Theme.of(context).accentColor,
                  ),
                )
            ],
          );
        } else {
          return Container(
            constraints: BoxConstraints(minHeight: 0),
            height: widget.cardHeight,
            child: Loading(),
          );
        }
      },
    );
  }

  Widget _buildFavoriteClubCard(FavoriteLoadedState state, int index, double distance) {
    var absDistance = distance.abs() > 1 ? 1 : distance.abs();
    return Transform.scale(
      scale: 1.0 - (absDistance > 0.15 ? 0.15 : absDistance),
      child: FavoriteClubCard(
        state.clubs[index],
        () => Router.push(context: context, builder: (_) => ClubDetailPage(state.clubs[index])).then(
          (_) => widget.onClubChange(state.clubs[index]),
        ),
      ),
    );
  }

}