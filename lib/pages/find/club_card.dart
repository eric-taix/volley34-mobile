import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';

class ClubCard extends StatefulWidget {
  final Club club;
  final int index;
  final Function(GlobalKey) onFavoriteTap;

  ClubCard(this.club, this.index, this.onFavoriteTap);

  @override
  _ClubCardState createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {

  Key _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: double.infinity),
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Card(
            child: InkWell(
              onTap: () => print("Tapped"),
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0, right: 8.0, bottom: 12.0, left: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.club.shortName,
                        style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(widget.club.name, style: Theme.of(context).textTheme.body1.copyWith(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: RoundedNetworkImage(40, widget.club.logoUrl),
      ),
      Align(
        alignment: Alignment.topRight,
        child: InkWell(
          key: _key,
          onTap: () => widget.onFavoriteTap?.call(_key),
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 24.0, bottom: 12.0, right: 24.0),
            child: Icon(
              widget.club.favorite ? Icons.star : Icons.star_border,
              size: 26,
              color: widget.club.favorite ? Colors.yellow : Theme.of(context).textTheme.body2.color,
            ),
          ),
        ),
      ),
    ]);
  }
}
