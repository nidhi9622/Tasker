import 'package:flutter/material.dart';

class DialogTile extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const DialogTile({Key? key, required this.text, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: TextButton(
          onPressed: onTap,
          child: Center(
              child: Text(
                text,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              )),
        ),
      ),
    );
}
