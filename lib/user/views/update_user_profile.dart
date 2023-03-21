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
import '../helper_widgets/get_image.dart';
import '../helper_widgets/profile_text_field.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  String profileImage = "";
  String? name;
  String? designation;
  String? phone;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  setData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('name', nameController.text);
    preferences.setString('number', phoneController.text);
    preferences.setString('designation', designationController.text);
    if (profileImage != "") {
      preferences.setString('imageUrl', profileImage);
    }
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('name');
      phone = preferences.getString('number');
      designation = preferences.getString('designation');
    });
    if (preferences.containsKey('imageUrl')) {
      setState(() {
        profileImage = preferences.getString('imageUrl') ?? "";
      });
    }
    nameController = TextEditingController(text: name ?? '');
    phoneController = TextEditingController(text: phone ?? '');
    designationController = TextEditingController(text: designation ?? '');
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CommonAppBar(
          text: 'profile'.tr,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              await titleErrorDialog(
                  context: context,
                  content: "profileUpdated".tr,
                  isTitle: true);
              await setData();
              setState(() {
                selectIndex = 4;
              });
              AppRoutes.go(AppRouteName.homePage);
            }
          },
          isLeading: true, isAction: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
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
                          decoration: profileImage==""
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
                                      image: FileImage(File(profileImage),
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
                      hintText: name ?? '',
                      labelText: 'name'.tr,
                      isNumber: false,
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      controller: nameController,
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
                      onChange: (String text) {
                        setState(() {
                          textColor = Colors.transparent;
                          borderColor = Colors.black;
                        });
                      },
                      icon: CupertinoIcons.person,
                      isPassword: false),
                  ProfileTextField(
                    context: context,
                    hintText: designation ?? '',
                    labelText: 'designation'.tr,
                    isNumber: false,
                    controller: designationController,
                    icon: Icons.work,
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.next,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'designationError'.tr;
                      }
                      return null;
                    },
                    onChange: (String text) {
                      setState(() {
                        textColor = Colors.transparent;
                        borderColor = Colors.black;
                      });
                    },
                    isPassword: false,
                  ),
                  ProfileTextField(
                      context: context,
                      hintText: phone ?? '',
                      labelText: 'number'.tr,
                      isNumber: true,
                      inputType: TextInputType.number,
                      inputAction: TextInputAction.done,
                      controller: phoneController,
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
                      onChange: (String text) {
                        setState(() {
                          textColor = Colors.transparent;
                          borderColor = Colors.black;
                        });
                      },
                      icon: CupertinoIcons.device_phone_portrait,
                      isPassword: false),
                ],
              ),
            ),
          ),
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
                      profileImage = await image;
                      setState(() {});
                    },
                    child: Text(
                      "camera".tr,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                      onTap: () async {
                        AppRoutes.pop();
                        var image = getImage(source: ImageSource.gallery);
                        profileImage = await image;
                        setState(() {});
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
