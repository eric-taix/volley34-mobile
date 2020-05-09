import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/favorite/favorite_icon.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/commons/favorite/favorite.dart';

class AppBarWithImage extends StatelessWidget {
  final String title;
  final String subTitle;
  final List<TextTab> tabs;
  final String logoUrl;
  final Favorite favorite;
  final String heroTag;

  AppBarWithImage(this.title, this.heroTag,
      {@required this.tabs, this.logoUrl, this.subTitle, this.favorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 120.0,
                elevation: 0,
                pinned: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(10.0),
                  child: subTitle != null
                      ? Row(
                          children: <Widget>[
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(subTitle,
                                  style: Theme.of(context).textTheme.body2),
                            ),
                            Spacer(),
                          ],
                        )
                      : SizedBox(),
                ),
                flexibleSpace: FlexibleSpaceBar(

                  centerTitle: true,
                  title: PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (logoUrl != null)
                            Hero(
                              tag: "hero-logo-$heroTag",
                              child: RoundedNetworkImage(
                                30,
                                logoUrl,
                                borderSize: 0,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 4),
                            child: Text(title,
                                style: Theme.of(context)
                                    .appBarTheme
                                    .textTheme
                                    .title),
                          ),
                          if (favorite != null)
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 40),
                              child: FavoriteIcon(
                                favorite.id,
                                favorite.type,
                                favorite.value,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TextTabBar(tabs: tabs),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: [
              ...tabs.map((tab) => tab.child).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TextTabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
