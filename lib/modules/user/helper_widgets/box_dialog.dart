import 'package:flutter/material.dart';
import 'dialog_tile.dart';

Future boxDialog({
  required BuildContext context,
  required String titleText,
  required String tileTextFirst,
  required String tileTextSecond,
  required VoidCallback tileTapFirst,
  required VoidCallback tileTapSecond,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
        title: Text(titleText),
        content: SizedBox(
          height: 130,
          child: Column(
            children: [
              DialogTile(text: tileTextFirst, onTap: tileTapFirst),
              DialogTile(text: tileTextSecond, onTap: tileTapSecond),
            ],
          ),
        ),
      ),
  );
}
