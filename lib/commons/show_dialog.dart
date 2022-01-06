import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String title, String message, {Function(BuildContext)? onPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message, style: Theme.of(context).textTheme.bodyText2),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (onPressed != null) onPressed(context);
              Navigator.pop(context);
            },
            child: Text("Fermer"),
          ),
        ],
      );
    },
  );
}

void showHelpDialog(BuildContext context, String title, List<String> paragraphs, {Function()? onPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).textTheme.headline5!.color,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(title, style: Theme.of(context).textTheme.headline5),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 18),
            ...paragraphs.map((paragraph) => Text(paragraph, style: Theme.of(context).textTheme.bodyText2))
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (onPressed != null) onPressed();
              Navigator.pop(context);
            },
            child: Text("Fermer"),
          ),
        ],
      );
    },
  );
}
