import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/project/views/projects.dart';
import 'package:task_manager/dashboard/helper_methods/search.dart';
import 'package:task_manager/user/views/settings.dart';
import 'package:task_manager/user/views/updateUserProfile.dart';
import 'package:task_manager/user/views/userProfile.dart';

class NewUserProfile extends StatefulWidget {
  const NewUserProfile({Key? key}) : super(key: key);

  @override
  State<NewUserProfile> createState() => _NewUserProfileState();
}

class _NewUserProfileState extends State<NewUserProfile> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      //bottomNavigationBar: bottomNavigation(context,(int i){setState((){bottomIndex = i;});}, 4),
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: Search(text: ''));
                },
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
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 15),
        child: Row(
          children: [
            exploreOptions(
                deviceSize, 'setting'.tr, CupertinoIcons.settings_solid, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            }, context),
            SizedBox(width: deviceSize.width * 0.055),
            exploreOptions(deviceSize, 'allTask'.tr, CupertinoIcons.doc, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Projects()));
            }, context),
            SizedBox(width: deviceSize.width * 0.055),
            exploreOptions(deviceSize, 'login'.tr, Icons.login_outlined, () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserProfile()));
            }, context)
          ],
        ),
      ),
    );
  }
}
