import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLeading;
  final List<Widget> actions;
  final String text;

  DefaultAppBar(
      {Key? key,
      required this.isLeading,
      required this.actions,
      required this.text})
      : super(key: key);
  final AppBar appBar = AppBar(
    title: const Text('Demo'),
  );

  @override
  AppBar build(BuildContext context) => AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          text,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        actions: actions,
      );

  @override
  Size get preferredSize =>
      Size(appBar.preferredSize.width, appBar.preferredSize.height);
}
