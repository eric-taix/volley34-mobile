import 'package:flutter/material.dart';
import 'package:v34/commons/no_data.dart';
import 'package:v34/commons/tab_bar.dart';

class FindPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
            length: 2,
            child: TextTabBar(tabs: [
              TextTab("Clubs", NoData("A venir...")),
              TextTab("Gymnases", NoData("A venir...")),
            ])));
  }
}
