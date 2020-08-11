import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/widgets/team_card.dart';

typedef TeamFavoriteChangeCallback = void Function(Team team);

class DashboardClubTeams extends StatefulWidget {
  final List<Team> teams;
  final Club club;
  final Function() onFavoriteTeamsChange;
  final double cardHeight = 240;

  const DashboardClubTeams({Key key, @required this.teams, @required this.club, this.onFavoriteTeamsChange}) : super(key: key);

  @override
  _DashboardClubTeamsState createState() => _DashboardClubTeamsState();
}

class _DashboardClubTeamsState extends State<DashboardClubTeams> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // AutomaticKeepAliveClientMixin permits to preserve this state when scrolling on the dashboard

  PageController _pageController;
  int _currentIndex = 0;
  double _currentTeamPage = 0;

  @override
  void initState() {
    _pageController = PageController()
      ..addListener(() {
        var nextIndex = _pageController.page.round();
        setState(() => _currentTeamPage = _pageController.page);
        if (nextIndex != _currentIndex) {
          _currentIndex = nextIndex;
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
      Container(
        height: widget.cardHeight,
        child: PageView.builder(
          physics: const BouncingScrollPhysics(),
          controller: _pageController,
          itemCount: widget.teams.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 0),
              child: TeamCard(
                currentlyDisplayed: _currentIndex == index,
                team: widget.teams[index],
                club: widget.club,
                distance: _currentTeamPage - index,
                onFavoriteChange: widget.onFavoriteTeamsChange,
              ),
            );
          },
        )
      ),
      if (widget.teams.length > 1) Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.teams.length,
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              dotColor: Theme.of(context).cardTheme.color,
              activeDotColor: Theme.of(context).accentColor,
            ),
          ),
        )
      )
    ]);
  }

  @override
  bool get wantKeepAlive => true;

}
