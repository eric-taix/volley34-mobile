import 'package:flutter/material.dart';

class PostponedBadge extends StatelessWidget {
  const PostponedBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration:
          BoxDecoration(color: Theme.of(context).textTheme.bodyText1!.color, borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Text(
          "R",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontWeight: FontWeight.w900, color: Theme.of(context).cardTheme.color),
        ),
      ),
    );
  }
}
