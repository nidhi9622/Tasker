import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import 'package:task_manager/project/helper_methods/title_error_dialog.dart';
import '../../app_utils/app_routes.dart';
import '../../app_utils/global_data.dart';
import '../controller/user_controller.dart';
import '../helper_widgets/get_image.dart';
import '../helper_widgets/profile_text_field.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserController controller = Get.put(UserController());

  setData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name', controller.nameController.value.text);
    preferences.setString('number', controller.phoneController.value.text);
    preferences.setString('designation', controller.designationController.value.text);
    if (controller.profileImage.value != "") {
      preferences.setString('imageUrl', controller.profileImage.value);
    }
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    controller.name.value = preferences.getString('name') ?? "";
    controller.designation.value = preferences.getString('designation') ?? "";
    controller.phone.value = preferences.getString('number') ?? "";
    if (preferences.containsKey('imageUrl')) {
      controller.profileImage.value = preferences.getString('imageUrl') ?? "";
    }
    controller.nameController.value = TextEditingController(text: controller.name.value );
    controller.phoneController.value = TextEditingController(text: controller.phone.value );
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
            setState(() {
              selectIndex = 4;
            });
            AppRoutes.go(AppRouteName.homePage);
          }
        },
        isLeading: true,
        isAction: true,
      ),
      body: Obx(() {
          return SingleChildScrollView(
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
                                    border:
                                        Border.all(width: 2, color: Colors.black),
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                        image: AssetImage("assets/personImage.jpg"),
                                        fit: BoxFit.fill))
                                : BoxDecoration(
                                    border:
                                        Border.all(width: 2, color: Colors.black),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(File(controller.profileImage.value),
                                            scale: 10.0),
                                        fit: BoxFit.fill))),
                        Padding(
                            padding: const EdgeInsets.all(2),
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: IconButton(
                                  onPressed: () {
                                    bottomSheet();
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
                    ProfileTextField(
                        context: context,
                        hintText: controller.name.value,
                        labelText: 'name'.tr,
                        isNumber: false,
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        controller: controller.nameController.value,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'nameError'.tr;
                          } else {
                            String pattern = r'(?=.*?[A-Z])(?=.*?[a-z])';
                            String newPattern = pattern.toLowerCase();
                            if (!RegExp(newPattern).hasMatch(value)) {
                              return "nameError1".tr;
                            }
                          }
                          return null;
                        },
                        icon: CupertinoIcons.person,
                        isPassword: false),
                    ProfileTextField(
                      context: context,
                      hintText: controller.designation.value ,
                      labelText: 'designation'.tr,
                      isNumber: false,
                      controller: controller.designationController.value,
                      icon: Icons.work,
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'designationError'.tr;
                        }
                        return null;
                      },
                      isPassword: false,
                    ),
                    ProfileTextField(
                        context: context,
                        hintText: controller.phone.value ,
                        labelText: 'number'.tr,
                        isNumber: true,
                        inputType: TextInputType.number,
                        inputAction: TextInputAction.done,
                        controller: controller.phoneController.value,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'numberError'.tr;
                          } else {
                            if (value.length != 10) {
                              return 'numberError1'.tr;
                            }
                          }
                          return null;
                        },
                        icon: CupertinoIcons.device_phone_portrait,
                        isPassword: false),
                  ],
                ),
              ),
            ),
          );
        }
      ));

  void bottomSheet() {
    showModalBottomSheet(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        backgroundColor: Colors.grey,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                height: 150,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        AppRoutes.pop();
                        var image = getImage(source: ImageSource.camera);
                        controller.profileImage.value = await image;
                      },
                      child: Text(
                        "camera".tr,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                        onTap: () async {
                          AppRoutes.pop();
                          var image = getImage(source: ImageSource.gallery);
                          controller.profileImage.value = await image;
                        },
                        child: Text('gallery'.tr,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)))
                  ],
                ),
              ),
            ));
  }
}

Color textColor = Colors.grey;
Color borderColor = Colors.brown;
