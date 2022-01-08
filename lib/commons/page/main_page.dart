import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:v34/commons/search.dart';

class MainPage extends StatefulWidget {
  final String title;
  final List<Widget>? slivers;
  final List<Widget>? actions;
  final ScrollController? scrollController;
  final Function(String)? onSearch;
  MainPage({this.title = "", this.slivers, this.actions, this.scrollController, this.onSearch});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: false,
          snap: false,
          floating: true,
          centerTitle: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
          title: Search(
            title: Text(widget.title),
            onSearch: widget.onSearch,
          ),
          actions: [
            if (widget.actions != null) ...widget.actions!,
          ],
        ),
        if (widget.slivers != null) ...widget.slivers!,
      ],
      controller: widget.scrollController,
    );
  }
}
