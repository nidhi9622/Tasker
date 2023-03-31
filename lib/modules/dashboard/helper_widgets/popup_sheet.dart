import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupSheet extends StatelessWidget {
  final VoidCallback onTapFirst;
  final VoidCallback onTapSecond;

  const PopupSheet({
    Key? key,
    required this.onTapFirst,
    required this.onTapSecond,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PopupMenuButton<int>(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: InkWell(
              onTap: onTapFirst,
              child: Row(
                children: const [
                  Icon(CupertinoIcons.pen),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Edit")
                ],
              ),
            ),
          ),
          PopupMenuItem(
            value: 2,
            onTap: onTapSecond,
            child: Row(
              children: const [
                Icon(CupertinoIcons.delete),
                SizedBox(
                  width: 10,
                ),
                Text("Delete")
              ],
            ),
          ),
        ],
        offset: const Offset(0, 100),
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
      );
}
