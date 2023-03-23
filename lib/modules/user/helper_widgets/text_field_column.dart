import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/user/helper_widgets/profile_text_field.dart';

import '../controller/user_controller.dart';

class TextFieldColumn extends StatelessWidget {
  final UserController controller;
  const TextFieldColumn({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          hintText: controller.designation.value,
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
            hintText: controller.phone.value,
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
    );
  }
}
