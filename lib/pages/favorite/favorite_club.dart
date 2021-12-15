import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/repository.dart';

class FavoriteClubSelection extends StatefulWidget {
  final Function(Club) onClubChange;

  const FavoriteClubSelection({Key? key, required this.onClubChange}) : super(key: key);

  @override
  State<FavoriteClubSelection> createState() => _FavoriteClubSelectionState();
}

class _FavoriteClubSelectionState extends State<FavoriteClubSelection> {
  final ItemScrollController itemScrollController = ItemScrollController();
  late Repository _repository;
  List<Club> _clubs = [];

  @override
  void initState() {
    super.initState();
    _repository = RepositoryProvider.of<Repository>(context);
    _repository.loadAllClubs().then((clubs) {
      _clubs = clubs..sort((c1, c2) => c1.shortName!.toLowerCase().compareTo(c2.shortName!.toLowerCase()));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      itemCount: _clubs.length,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () => _selectClub(index),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              child: Row(
                children: [
                  _clubs[index].logoUrl != null
                      ? CachedNetworkImage(
                          imageUrl: _clubs[index].logoUrl!,
                          height: 50,
                          width: 50,
                          errorWidget: (_, __, ___) => SizedBox(width: 50, height: 50),
                        )
                      : SizedBox(width: 50, height: 50),
                  Expanded(
                    //fit: FlexFit.loose,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_clubs[index].shortName!, style: Theme.of(context).textTheme.bodyText2),
                          Text(
                            _clubs[index].name!,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 16,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectClub(int index) {
    widget.onClubChange(_clubs[index]);
  }
}
