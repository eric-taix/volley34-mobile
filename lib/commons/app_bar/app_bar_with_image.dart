import 'package:flutter/material.dart';
import 'package:page_view_indicators/animated_circle_page_indicator.dart';
import 'package:v34/commons/app_bar/animated_logo.dart';
import 'package:v34/commons/app_bar/app_bar.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/favorite/favorite_icon.dart';
import 'package:v34/commons/loading.dart';

class _AppBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String? imageUrl;
  final String? title;
  final String? subTitle;
  final String heroTag;
  final Favorite? favorite;
  final Widget? bottom;

  _AppBarHeaderDelegate({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.heroTag,
    required this.favorite,
    this.bottom,
  });

  static IconData? _getIconData(TargetPlatform platform) {
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
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    final appBarTheme = Theme.of(context).appBarTheme;

    var compute = computeLinear(shrinkOffset, minExtent, maxExtent);

    return Container(
      color: Theme.of(context).canvasColor,
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
                      color: appBarTheme.backgroundColor,
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
                child: Container(
                  child: Text(
                    subTitle ?? "",
                    style: appBarTheme.toolbarTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: compute(kSystemBarHeight + 2, - compute(38.0, 60.0) / 2),
            left: compute(75.0, 80.0),
            width: MediaQuery.of(context).size.width - 75,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.0, bottom: compute(0.0, 22.0)),
                      child: Text(
                        title ?? "",
                        style: appBarTheme.titleTextStyle,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ),
                  if (favorite != null)
                    FavoriteIcon(
                      favorite!.id,
                      favorite!.type,
                      padding: EdgeInsets.only(left: 12, bottom: compute(0.0, 22.0), right: 8),
                    ),
                ],
              ),
            ),
          ),
          AnimatedLogo(
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
                          color: appBarTheme.titleTextStyle!.color,
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
  double get maxExtent => kToolbarHeight + 70.0 + kToolbarMargin + kSystemBarHeight;

  @override
  double get minExtent => kToolbarHeight + kToolbarMargin + kSystemBarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class AppBarWithImage extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? logoUrl;
  final Favorite? favorite;
  final String heroTag;

  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;

  AppBarWithImage(
    this.title,
    this.heroTag, {
    Key? key,
    this.logoUrl,
    this.subTitle,
    this.favorite,
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  }) : super(key: key);

  @override
  _AppBarWithImageState createState() => _AppBarWithImageState();
}

class _AppBarWithImageState extends State<AppBarWithImage> with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;
  late final ValueNotifier<int> _currentPageNotifier;
  late final ScrollController _scrollController;
  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    _currentPageNotifier = ValueNotifier<int>(_currentPosition);
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation?.addListener(onScroll);
    _currentCount = widget.itemCount;
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void didUpdateWidget(AppBarWithImage oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation?.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      _currentPosition = widget.initPosition ?? _currentPosition;
      _currentPageNotifier.value = _currentPosition;
      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        _currentPageNotifier.value = _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              if (widget.onPositionChange != null) widget.onPositionChange!(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation?.addListener(onScroll);
      });
    } else {
      controller.animateTo(widget.initPosition ?? _currentPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.animation?.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      _currentPageNotifier.value = _currentPosition;
      if (widget.onPositionChange != null && widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll != null && widget.onScroll is ValueChanged<double> && controller.animation != null) {
      widget.onScroll!(controller.animation!.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      child: NestedScrollView(
        controller: _scrollController,
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
                    decoration: !_scrollController.hasClients ||
                            _scrollController.offset < _scrollController.position.maxScrollExtent
                        ? null
                        : BoxDecoration(
                            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
                            Theme.of(context).canvasColor,
                            Colors.transparent,
                          ], stops: [
                            0.97,
                            1,
                          ])),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TabBar(
                                  isScrollable: true,
                                  controller: controller,
                                  dividerHeight: 0,
                                  //indicatorPadding: EdgeInsets.symmetric(horizontal: 12.0),
                                  tabs: List.generate(
                                    widget.itemCount,
                                    (index) {
                                      return widget.tabBuilder(context, index);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 0,
                            left: 0,
                            child: AnimatedCirclePageIndicator(
                              itemCount: widget.itemCount,
                              currentPageNotifier: _currentPageNotifier,
                              radius: 4,
                              activeRadius: 3,
                              fillColor: Colors.transparent,
                              activeColor: Theme.of(context).colorScheme.secondary,
                              spacing: 8,
                              borderColor: Theme.of(context).colorScheme.secondary,
                              borderWidth: 1,
                              duration: Duration(milliseconds: 100),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: widget.itemCount > 0
            ? Container(
                child: TabBarView(
                  controller: controller,
                  children: List.generate(
                    widget.itemCount,
                    (index) {
                      return SafeArea(
                        top: false,
                        bottom: false,
                        left: false,
                        child: Builder(
                          builder: (BuildContext context) {
                            return CustomScrollView(
                              key: PageStorageKey<String>("page$index"),
                              slivers: <Widget>[
                                SliverOverlapInjector(
                                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.only(top: 0.0, right: 0.0, bottom: 48.0, left: 0.0),
                                  sliver: widget.pageBuilder(context, index),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            : Center(child: Loading()),
      ),
    );
  }
}
