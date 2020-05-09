import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club/club_card.dart';
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
    _loadClubs();
  }

  @override
  void didUpdateWidget(ClubPage oldWidget) async {
    _loadClubs();
    super.didUpdateWidget(oldWidget);
  }

  void _loadClubs() {
    setState(() {
      _loading = true;
    });
    _repository.loadAllClubs().then((clubs) {
      setState(() {
        _loading = false;
        _clubs = clubs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : Stack(children: <Widget>[
            AnimationLimiter(
              child: ListView.builder(
                itemCount: _clubs.length + 1,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Paragraph(title: "Liste des clubs")
                      : index < _clubs.length
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
