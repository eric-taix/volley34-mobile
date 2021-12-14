import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, String title, String message, {Function()? onPressed}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
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
