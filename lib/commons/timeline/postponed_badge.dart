import 'package:flutter/material.dart';

class PostponedBadge extends StatelessWidget {
  const PostponedBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.timer, size: 20, color: Theme.of(context).textTheme.bodyText1!.color),
    );
  }
}
