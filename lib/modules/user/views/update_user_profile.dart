import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../../project/helper_methods/title_error_dialog.dart';
import '../controller/user_controller.dart';
import '../helper_methods/image_sheet.dart';
import '../helper_widgets/text_field_column.dart';

class UpdateUserProfile extends StatefulWidget {
  const UpdateUserProfile({Key? key}) : super(key: key);

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserController controller = Get.put(UserController());

  setData() async {
    GetPrefs.setString(GetPrefs.userName, controller.nameController.value.text);
    GetPrefs.setString(
        GetPrefs.userNumber, controller.phoneController.value.text);
    GetPrefs.setString(
        GetPrefs.userDesignation, controller.designationController.value.text);
    if (controller.profileImage.value != "") {
      GetPrefs.setString(GetPrefs.userImage, controller.profileImage.value);
    }
    GetPrefs.setBool(GetPrefs.isLoggedIn, true);
  }

  getData() async {
    controller.name.value = GetPrefs.getString(GetPrefs.userName);
    controller.designation.value = GetPrefs.getString(
      GetPrefs.userDesignation,
    );
    controller.phone.value = GetPrefs.getString(
      GetPrefs.userNumber,
    );
    if (GetPrefs.containsKey(GetPrefs.userImage)) {
      controller.profileImage.value = GetPrefs.getString(GetPrefs.userImage);
    }
    controller.nameController.value =
        TextEditingController(text: controller.name.value);
    controller.phoneController.value =
        TextEditingController(text: controller.phone.value);
    controller.designationController.value =
        TextEditingController(text: controller.designation.value);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: CommonAppBar(
        text: 'profile'.tr,
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            await titleErrorDialog(
                context: context, content: "profileUpdated".tr, isTitle: true);
            await setData();
            selectIndex.value = 4;
            AppRoutes.go(AppRouteName.bottomNavPage);
          }
        },
        isLeading: true,
        isAction: true,
      ),
      body: Obx(() => SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                            height: 150,
                            width: 150,
                            decoration: controller.profileImage.value == ""
                                ? BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/personImage.jpg"),
                                        fit: BoxFit.fill))
                                : BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(
                                            File(controller.profileImage.value),
                                            scale: 10.0),
                                        fit: BoxFit.fill))),
                        Padding(
                            padding: const EdgeInsets.all(2),
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: IconButton(
                                  onPressed: () async {
                                    await Permission.camera.request();
                                    await Permission.photos.request();
                                    bottomSheet(controller: controller);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.add,
                                    color: Colors.black,
                                  ),
                                )))
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    TextFieldColumn(controller: controller)
                  ],
                ),
              ),
            ),
          )));
}
