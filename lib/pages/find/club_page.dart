import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:v34/commons/particle/particle_controller.dart';
import 'package:v34/commons/particle/particle_field_painter.dart';
import 'package:v34/main.dart';
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
  final Repository _repository = Repository(
    clubProvider: ClubProvider(),
    favoriteProvider: FavoriteProvider(),
    teamProvider: TeamProvider(),
    agendaProvider: AgendaProvider(),
  );
  List<Club> _clubs;
  bool _loading = false;

  ParticleController _particleController;

  @override
  void initState() {
    super.initState();

    _particleController = ParticleController(this, V34.pkg);

    _repository.loadClubs().then((clubs) {
      setState(() {
        _clubs = clubs;
        _loading = false;
      });
    });
    setState(() => _loading = true);
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
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
                              child: ClubCard(_clubs[index], index, (key, {action}) => _performToggleFavorite(_clubs[index], key, context)),
                            ),
                          ),
                        )
                      : SizedBox(height: 56);
                },
              ),
            ),
            Positioned.fill(
                child: IgnorePointer(
              child: CustomPaint(painter: ParticleFieldPainter(controller: _particleController)),
            )),
          ]);
  }

  void _performToggleFavorite(Club club, GlobalKey key, BuildContext context) {
    setState(() {
      if (club.toggleFavorite()) {
        _repository.saveFavoriteClubs(_clubs.where((club) => club.favorite).toList()).then((value) {
          _particleController.lineExplosion(key, context, Colors.yellow);
        });
      } else {
        _repository.saveFavoriteClubs(_clubs.where((club) => club.favorite).toList()).then((value) {
          _particleController.pointExplosion(key, context, Theme.of(context).textTheme.body2.color, 100);
        });
      }
    });
  }
}
