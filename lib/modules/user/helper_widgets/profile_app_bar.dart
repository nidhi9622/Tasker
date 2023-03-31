import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/helper_methods/search.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List searchList;

  ProfileAppBar({
    Key? key,
    required this.searchList,
  }) : super(key: key);
  final AppBar appBar = AppBar(
    title: const Text('Demo'),
  );

  @override
  AppBar build(BuildContext context) => AppBar(
          actions: [
            IconButton(
                onPressed: () => showSearch(
                    context: context,
                    delegate: Search(text: '', totalProjectList: searchList)),
                icon: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).primaryColorDark,
                ))
          ],
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'profile'.tr,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ));

  @override
  Size get preferredSize =>
      Size(appBar.preferredSize.width, appBar.preferredSize.height);
}
