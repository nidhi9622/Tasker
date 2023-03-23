import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/shared_prefs/shared_prefs.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../controller/user_controller.dart';
import '../helper_widgets/explore_options.dart';
import '../helper_widgets/profile_app_bar.dart';

class UserProfile extends StatefulWidget {
  final bool isOldUser;

  const UserProfile({Key? key, required this.isOldUser}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // String? name;
  // String? designation;
  // dynamic profileImage;
  UserController controller = Get.put(UserController());

  getData() async {
    controller.name.value = SharedPrefs.getString(SharedPrefs.userName);
    controller.designation.value = SharedPrefs.getString(SharedPrefs.userDesignation);
    if (SharedPrefs.containsKey(SharedPrefs.userImage)) {
      controller.profileImage.value = SharedPrefs.getString(SharedPrefs.userImage);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: ProfileAppBar(),
        body: SingleChildScrollView(
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isOldUser
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),
                            color: Theme.of(context).primaryColor),
                        child: Obx(() {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${projectItem.length}',
                                            style:
                                                TextStyle(color: Colors.red[200]),
                                          ),
                                          Text(
                                            'allTask'.tr,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                                fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                          child: Container(
                                              height: 180,
                                              width: 220,
                                              decoration: controller
                                                          .profileImage.value ==
                                                      ""
                                                  ? BoxDecoration(
                                                      color: Colors.black,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.black),
                                                      shape: BoxShape.circle,
                                                      image: const DecorationImage(
                                                          image: AssetImage(
                                                              "assets/personImage.jpg"),
                                                          fit: BoxFit.contain))
                                                  : BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.black),
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: FileImage(
                                                              File(controller.profileImage.value),
                                                              scale: 10.0),
                                                          fit: BoxFit.fill)))),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            '${ongoingProjects.length}',
                                            style:
                                                TextStyle(color: Colors.red[200]),
                                          ),
                                          Text(
                                            'ongoingTask'.tr,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                                fontSize: 10),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  controller.name.value,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  controller.designation.value,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      AppRoutes.go(AppRouteName.updateUserProfile);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.only(
                                          left: 34, right: 34),
                                      backgroundColor: Colors.red[200],
                                    ),
                                    child: Text(
                                      'editProfile'.tr,
                                      style: const TextStyle(color: Colors.white),
                                    )),
                                const SizedBox(
                                  height: 32,
                                )
                              ],
                            );
                          }
                        ),
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
                              AppRoutes.go(AppRouteName.homePage);
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
                                projectItem.clear();
                                upcomingProjects.clear();
                                ongoingProjects.clear();
                                completedProjects.clear();
                                canceledProjects.clear();
                                SharedPrefs.clear();
                                SharedPrefs.setBool(SharedPrefs.isLoggedIn, false);
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
            )
        ),
      );
}
