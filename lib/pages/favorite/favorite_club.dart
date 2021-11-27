import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/theme.dart';

class FavoriteClubSelection extends StatefulWidget {
  final Function(Club) onClubChange;

  const FavoriteClubSelection({Key? key, required this.onClubChange}) : super(key: key);

  @override
  State<FavoriteClubSelection> createState() => _FavoriteClubSelectionState();
}

class _FavoriteClubSelectionState extends State<FavoriteClubSelection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  late Repository _repository;
  Club? _favoriteClub;
  int? _selectedIndex;
  List<Club> _clubs = [];

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _repository
        .loadAllClubs()
        .then((clubs) =>
            _clubs = clubs..sort((c1, c2) => c1.shortName!.toLowerCase().compareTo(c2.shortName!.toLowerCase())))
        .then((_) => _repository.loadFavoriteClubCode())
        .then(
      (favoriteClubCode) {
        setState(
          () {
            _favoriteClub = _clubs.firstWhereOrNull((club) => club.code == favoriteClubCode);
            _selectedIndex = _favoriteClub != null ? _clubs.indexOf(_favoriteClub!) : null;
            if (_selectedIndex != null && _selectedIndex != -1) {
              widget.onClubChange(_clubs[_selectedIndex!]);
              Future.delayed(Duration(milliseconds: 200), () => itemScrollController.jumpTo(index: _selectedIndex!));
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      padding: EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      itemScrollController: itemScrollController,
      itemCount: _clubs.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: _selectedIndex == index
              ? TinyColor(Theme.of(context).cardTheme.color!).mix(input: Colors.white, amount: 20).color
              : null,
          margin: EdgeInsets.only(top: 4.0, bottom: 4.0, right: 8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
            onTap: () => _selectClub(index),
            child: Row(
              children: [
                _clubs[index].logoUrl != null
                    ? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            imageUrl: _clubs[index].logoUrl!,
                            height: 50,
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
        );
      },
    );
  }

  void _selectClub(int index) {
    widget.onClubChange(_clubs[index]);
    setState(() => _selectedIndex = index);
  }
}
