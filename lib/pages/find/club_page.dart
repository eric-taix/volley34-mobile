import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/find/club_card.dart';
import 'package:v34/repositories/providers/agenda_provider.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';
import 'package:v34/repositories/repository.dart';

class ClubPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> with SingleTickerProviderStateMixin {
  Repository _repository;

  List<Club> _clubs;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _repository.loadClubs().then((clubs) {
      setState(() {
        _clubs = clubs;
        _loading = false;
      });
    });
    setState(() => _loading = true);
  }


  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : Stack(children: <Widget>[
            AnimationLimiter(
              child: ListView.builder(
                itemCount: _clubs.length,
                itemBuilder: (context, index) {
                  return index < _clubs.length
                      ? AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: ClubCard(_clubs[index], index),
                            ),
                          ),
                        )
                      : SizedBox(height: 56);
                },
              ),
            ),
          ]);
  }
}
