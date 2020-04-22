import 'package:flutter/material.dart';

class CustomDialog{
  static Future<bool> validationDialog(BuildContext context, String title, String description) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              title,
              style: Theme.of(context).textTheme.title.copyWith(color: Colors.black)
          ),
          content: Text(
              description,
              style: Theme.of(context).textTheme.body1.copyWith(color: Colors.black)
          ),
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          actions: <Widget>[
            FlatButton(
              child: Text("Annuler"),
              onPressed: () {
                // Pop the dialog with false
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("Confirmer"),
              onPressed: () {
                // Pop the dialog with true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}


