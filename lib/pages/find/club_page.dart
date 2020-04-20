import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/find/club_card.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/v34_repository.dart';

class ClubPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final V34Repository _repository = V34Repository(ClubProvider());
  List<Club> _clubs;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _repository.getAllClubs().then((clubs) {
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
        : AnimationLimiter(
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
                            child: ClubCard(
                              _clubs[index],
                              index,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 56);
              },
            ),
          );
  }
}
