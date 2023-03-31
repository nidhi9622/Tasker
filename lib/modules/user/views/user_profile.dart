import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/shared_prefs/get_prefs.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/project_status.dart';
import '../../project/helper_widgets/upper_profile_body.dart';
import '../helper_widgets/explore_options.dart';
import '../helper_widgets/profile_app_bar.dart';

class UserProfile extends StatefulWidget {
  final bool isOldUser;

  const UserProfile({Key? key, required this.isOldUser}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List totalProjectList = [];
  List ongoingProjects = [];

  getProjectItem() async {
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      totalProjectList = jsonDecode(map);
      ongoingProjects.clear();
      for (int i = 0; i < totalProjectList.length; i++) {
        if (totalProjectList[i]["projectStatus"] ==
            "${ProjectStatus.ongoing}") {
          ongoingProjects.add(totalProjectList[i]);
        }
      }
    }
  }

  @override
  void initState() {
    getProjectItem();
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      totalProjectList = jsonDecode(map);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ProfileAppBar(
          searchList: totalProjectList,
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isOldUser
                ? UpperProfileBody(
                    totalProjectList: totalProjectList,
                    ongoingProjects: ongoingProjects,
                  )
                : const SizedBox.shrink(),
            widget.isOldUser
                ? Padding(
                    padding: const EdgeInsets.only(top: 18, left: 15),
                    child: Text(
                      'Explore'.tr,
                      style: const TextStyle(fontSize: 19),
                    ),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ExploreOptions(
                        onTap: () {
                          AppRoutes.go(AppRouteName.settings);
                        },
                        iconData: CupertinoIcons.settings,
                        text: 'setting'.tr),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ExploreOptions(
                      onTap: () {
                        if (widget.isOldUser) {
                          selectIndex.value = 1;
                          AppRoutes.go(AppRouteName.bottomNavPage);
                        } else {
                          AppRoutes.go(AppRouteName.projects);
                        }
                      },
                      iconData: CupertinoIcons.doc,
                      text: 'allTask'.tr,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ExploreOptions(
                        onTap: () async {
                          if (widget.isOldUser) {
                            GetPrefs.clear();
                            GetPrefs.setBool(GetPrefs.isLoggedIn, false);
                            AppRoutes.go(AppRouteName.splash);
                          } else {
                            AppRoutes.go(AppRouteName.updateUserProfile);
                          }
                        },
                        iconData: widget.isOldUser
                            ? Icons.logout_outlined
                            : Icons.login_outlined,
                        text: widget.isOldUser ? 'logOut'.tr : 'login'.tr),
                  ),
                ],
              ),
            )
          ],
        )),
      );
}
