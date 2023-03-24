import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/shared_prefs/shared_prefs.dart';
import '../../user/controller/user_controller.dart';

class UpperProfileBody extends StatefulWidget {
  const UpperProfileBody({Key? key}) : super(key: key);

  @override
  State<UpperProfileBody> createState() => _UpperProfileBodyState();
}

class _UpperProfileBodyState extends State<UpperProfileBody> {
  UserController controller = Get.put(UserController());

  getData() async {
    controller.name.value = GetPrefs.getString(GetPrefs.userName);
    controller.designation.value = GetPrefs.getString(GetPrefs.userDesignation);
    if (GetPrefs.containsKey(GetPrefs.userImage)) {
      controller.profileImage.value = GetPrefs.getString(GetPrefs.userImage);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
            color: Theme.of(context).primaryColor),
        child: Obx(() => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${projectItem.length}',
                            style: TextStyle(color: Colors.red[200]),
                          ),
                          Text(
                            'allTask'.tr,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
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
                              decoration: controller.profileImage.value == ""
                                  ? BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                      shape: BoxShape.circle,
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              "assets/personImage.jpg"),
                                          fit: BoxFit.contain))
                                  : BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.black),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(
                                              File(controller
                                                  .profileImage.value),
                                              scale: 10.0),
                                          fit: BoxFit.fill)))),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${ongoingProjects.length}',
                            style: TextStyle(color: Colors.red[200]),
                          ),
                          Text(
                            'ongoingTask'.tr,
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
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
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () {
                      AppRoutes.go(AppRouteName.updateUserProfile);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(left: 34, right: 34),
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
            )),
      );
}
