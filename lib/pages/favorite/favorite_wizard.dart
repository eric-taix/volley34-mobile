import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/theme.dart';

class SelectFavoriteClub extends StatefulWidget {
  const SelectFavoriteClub({Key? key}) : super(key: key);

  @override
  State<SelectFavoriteClub> createState() => _SelectFavoriteClubState();
}

class _SelectFavoriteClubState extends State<SelectFavoriteClub> {
  List<Club> _clubs = [];
  int? _selectedIndex;
  late Repository _repository;

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _repository.loadAllClubs().then(
          (clubs) => setState(
            () {
              _clubs = clubs;
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Sélectionnez votre club"),
      contentPadding: EdgeInsets.only(left: 10, top: 28),
      content: Container(
        width: double.minPositive,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _clubs.length,
                itemBuilder: (BuildContext context, int index) => Card(
                  color: _selectedIndex == index
                      ? TinyColor(Theme.of(context).cardTheme.color!).mix(input: Colors.white, amount: 20).color
                      : null,
                  margin: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Row(
                      children: [
                        _clubs[index].logoUrl != null
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: CachedNetworkImage(
                                    imageUrl: _clubs[index].logoUrl!,
                                    width: 50,
                                    errorWidget: (_, __, ___) => SizedBox(width: 50, height: 50),
                                  ),
                                ),
                              )
                            : SizedBox(width: 50, height: 50),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_clubs[index].shortName!),
                              Text(
                                _clubs[index].name!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: _selectedIndex != null ? () => _saveAndClose(context, _clubs[_selectedIndex!]) : null,
            child: Text("OK")),
        TextButton(onPressed: () => _close(context), child: Text("Annuler")),
      ],
    );
  }

  _saveAndClose(BuildContext context, Club club) async {
    await _repository.setFavorite(club.code, FavoriteType.Club);
    _close(context);
  }

  _close(BuildContext context) {
    Navigator.of(context).pop();
  }
}
