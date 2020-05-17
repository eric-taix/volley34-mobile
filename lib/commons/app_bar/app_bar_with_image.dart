import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/app_bar/animated_logo.dart';
import 'package:v34/commons/app_bar/app_bar.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/favorite/favorite_icon.dart';
import 'package:v34/commons/text_tab_bar.dart';

class _AppBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String imageUrl;
  final String title;
  final String subTitle;
  final String heroTag;
  final Favorite favorite;
  final Widget bottom;

  _AppBarHeaderDelegate({
    this.expandedHeight = 120,
    @required this.imageUrl,
    @required this.title,
    @required this.subTitle,
    @required this.heroTag,
    @required this.favorite,
    this.bottom,
  });

  static IconData _getIconData(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    final appBarTheme = Theme.of(context).appBarTheme;

    var compute = computeLinear(shrinkOffset, minExtent, maxExtent);

    return Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(compute(20.0, 30.0)),
                        bottomRight: Radius.circular(compute(20.0, 30.0)),
                      ),
                      color: appBarTheme.color,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: kToolbarMargin,
                    child: bottom,
                  ),
                ],
              )
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0 + kSystemBarHeight, left: 18),
              child: Opacity(
                opacity: compute(0.0, 1.0),
                child: Text(subTitle, style: appBarTheme.textTheme.subtitle2),
              ),
            ),
          ),
          Positioned(
            top: compute(kSystemBarHeight + 2, expandedHeight - compute(38.0, 60.0) / 2),
            left: compute(75.0, 80.0),
            width: MediaQuery.of(context).size.width - 75,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 14.0, bottom: compute(0.0, 22.0)),
                    child: Text(title, style: appBarTheme.textTheme.headline6),
                  ),
                  FavoriteIcon(
                    favorite.id,
                    favorite.type,
                    favorite.value,
                    padding: EdgeInsets.only(left: 12, bottom: compute(0.0, 22.0)),
                  ),
                ],
              ),
            ),
          ),
          AnimatedLogo(
            expandedHeight: expandedHeight,
            imageUrl: imageUrl,
            heroTag: heroTag,
            compute: computeLinear(shrinkOffset, minExtent, maxExtent),
          ),
          Positioned(
            top: kSystemBarHeight,
            left: 0,
            child: useCloseButton
                ? CloseButton()
                : Material(
                    color: Colors.transparent,
                    shape: CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.maybePop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          _getIconData(Theme.of(context).platform),
                          color: appBarTheme.textTheme.button.color,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + kToolbarMargin + kSystemBarHeight;

  @override
  double get minExtent => kToolbarHeight + kToolbarMargin + kSystemBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class AppBarWithImage extends StatefulWidget {
  final String title;
  final String subTitle;
  final List<TextTab> tabs;
  final String logoUrl;
  final Favorite favorite;
  final String heroTag;

  AppBarWithImage(this.title, this.heroTag, {@required this.tabs, this.logoUrl, this.subTitle, this.favorite});

  @override
  _AppBarWithImageState createState() => _AppBarWithImageState();
}

class _AppBarWithImageState extends State<AppBarWithImage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: DefaultTabController(
        length: widget.tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: _AppBarHeaderDelegate(
                    imageUrl: widget.logoUrl,
                    title: widget.title,
                    subTitle: widget.subTitle,
                    heroTag: widget.heroTag,
                    favorite: widget.favorite,
                    bottom: Container(
                      color: Theme.of(context).primaryColor,
                      child: TextTabBar(tabs: widget.tabs),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: widget.tabs.map((tab) {
              return SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (BuildContext context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>(tab.title),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverPadding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            sliver: SliverList(
                              delegate: SliverChildListDelegate([tab.child]),
                            )),
                      ],
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
