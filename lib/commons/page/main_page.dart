import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainPage extends StatelessWidget {
  final String title;
  final List<Widget>? slivers;
  final List<Widget>? actions;

  MainPage({this.title = "", this.slivers, this.actions});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverAppBar(
        pinned: false,
        snap: false,
        floating: true,
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
        title: Text(title),
        actions: actions,
      ),
      if (slivers != null) ...slivers!,
    ]);
  }
}
