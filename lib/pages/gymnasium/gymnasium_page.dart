import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/models/gymnasium.dart';
import 'package:v34/pages/gymnasium/gymnasium_card.dart';
import 'package:v34/pages/gymnasium/gymnasium_map.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/analytics.dart';

class GymnasiumPage extends StatefulWidget {
  @override
  _GymnasiumPageState createState() => _GymnasiumPageState();
}

class _GymnasiumPageState extends State<GymnasiumPage> with RouteAwareAnalytics {
  List<Gymnasium>? _gymnasiums;
  PageController? _pageController;
  String? _currentGymnasiumCode;
  bool _moving = false;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8)
      ..addListener(
        () {
          setState(
            () {
              if (!_moving) {
                _currentGymnasiumCode = _gymnasiums![_pageController!.page!.toInt()].gymnasiumCode;
              }
            },
          );
        },
      );
    RepositoryProvider.of<Repository>(context)
      ..loadAllGymnasiums()
          .then((gymnasiums) => setState(() {
                _gymnasiums = gymnasiums;
                _error = false;
              }))
          .onError((error, stackTrace) {
        setState(() {
          _error = true;
          _gymnasiums = [];
        });
      });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: "Gymnases",
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _buildMap(context),
          fillOverscroll: false,
        ),
      ],
    );
  }

  Widget _buildMap(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: _error
          ? SizedBox()
          : _gymnasiums != null
              ? Container(
                  child: Stack(children: [
                    GymnasiumMap(
                      gymnasiums: _gymnasiums,
                      currentGymnasiumCode: _currentGymnasiumCode,
                      onGymnasiumSelected: (selectedGymnasiumCode) {
                        int selectedGymnasiumIndex = _gymnasiums!.indexOf(selectedGymnasiumCode);
                        _moving = true;
                        _pageController!
                            .animateToPage(selectedGymnasiumIndex,
                                curve: Curves.easeInOut, duration: Duration(milliseconds: 1000))
                            .then((_) {
                          setState(() {
                            _moving = false;
                            _currentGymnasiumCode = _gymnasiums![_pageController!.page!.toInt()].gymnasiumCode;
                          });
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50),
                        height: 220,
                        child: PageView.builder(
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            return GymnasiumCard(gymnasium: _gymnasiums![index]);
                          },
                          itemCount: _gymnasiums!.length,
                        ),
                      ),
                    )
                  ]),
                )
              : Center(child: Loading()),
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.gymnasiums;
}
