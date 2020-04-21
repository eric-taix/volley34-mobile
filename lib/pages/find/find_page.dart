import 'package:flutter/material.dart';
import 'package:v34/commons/no_data.dart';
import 'package:v34/commons/tab_bar.dart';
import 'package:v34/pages/find/club_page.dart';

class FindPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
            length: 2,
            child: TextTabBar(tabs: [
              TextTab("Clubs", ClubPage()),
              TextTab("Gymnases", NoData("A venir...")),
            ])));
  }
}
