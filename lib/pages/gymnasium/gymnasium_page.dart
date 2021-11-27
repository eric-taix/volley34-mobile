import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/gymnasium.dart';
import 'package:v34/pages/gymnasium/gymnasium_card.dart';
import 'package:v34/pages/gymnasium/gymnasium_map.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/repositories/repository.dart';

class GymnasiumPage extends StatefulWidget {
  @override
  _GymnasiumPageState createState() => _GymnasiumPageState();
}

class _GymnasiumPageState extends State<GymnasiumPage> {
  List<Gymnasium>? _gymnasiums;
  PageController? _pageController;
  String? _currentGymnasiumCode;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8)
      ..addListener(() {
        setState(() => _currentGymnasiumCode = _gymnasiums![_pageController!.page!.toInt()].gymnasiumCode);
      });
    RepositoryProvider.of<Repository>(context)
      ..loadAllGymnasiums().then((gymnasiums) => setState(() {
            _gymnasiums = gymnasiums;
          }));
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
      sliver: SliverFillRemaining(hasScrollBody: false,child: _buildMap(context), fillOverscroll: false,),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: _gymnasiums != null
          ? Container(
              child: Stack(children: [
                GymnasiumMap(
                  gymnasiums: _gymnasiums,
                  currentGymnasiumCode: _currentGymnasiumCode,
                  onGymnasiumSelected: (selectedGymnasiumCode) {
                    int selectedGymnasiumIndex = _gymnasiums!.indexOf(selectedGymnasiumCode);
                    _pageController!.jumpToPage(selectedGymnasiumIndex);
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
}
