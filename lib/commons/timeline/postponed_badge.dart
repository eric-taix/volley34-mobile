import 'package:flutter/material.dart';

class PostponedBadge extends StatelessWidget {
  const PostponedBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).textTheme.bodyText1!.color!,
        ),
      ),
      child: Center(
        child: Text("R", style: Theme.of(context).textTheme.bodyText1!),
      ),
    );
  }
}
