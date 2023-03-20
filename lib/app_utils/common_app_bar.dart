import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String text;
  final VoidCallback onTap;

  CommonAppBar(
      {Key? key,
      required this.text, required this.onTap})
      : super(key: key);
  final AppBar appBar = AppBar(
    title: const Text('Demo'),
  );

  @override
  AppBar build(BuildContext context) => AppBar(
        elevation: 0,
        title: Text(
          text,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
        automaticallyImplyLeading: false,
      actions: [
        TextButton(
            onPressed: onTap,
            child: Text(
              'done'.tr,
              style: TextStyle(
                  color: Theme.of(context)
                      .primaryColorDark),
            ))
      ]
      );

  @override
  Size get preferredSize =>
      Size(appBar.preferredSize.width, appBar.preferredSize.height);
}
