import 'package:flutter/material.dart';
import 'package:v34/models/event.dart';
import 'package:v34/pages/dashboard/widgets/timeline/details/event_info.dart';

class EventDetails extends StatelessWidget {
  final Event event;

  const EventDetails({Key key, @required this.event}) : super(key: key);
  
  String _screenTitle() {
    if (event.type == EventType.Match) {
      return "Détails du match";
    } else {
      return event.name;
    }
  }

  Widget _buildAppBarBackground(BuildContext context) {
    if (event.imageUrl != null && event.imageUrl != "") {
      return Image.network(event.imageUrl, fit: BoxFit.cover);
    } else {
      return Container(color: Theme.of(context).appBarTheme.color);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    _screenTitle(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2.color,
                      fontSize: 16.0,
                    )
                  ),
                  background: _buildAppBarBackground(context)
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Theme.of(context).accentColor,
                    unselectedLabelColor: Theme.of(context).accentColor,
                    labelPadding: const EdgeInsets.only(top: 2.0),
                    tabs: [
                      SizedBox(
                        height: 46.0,
                        child: Center(
                          widthFactor: 1.0,
                          child: Text("Informations")
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              EventInfo(event: event)
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}