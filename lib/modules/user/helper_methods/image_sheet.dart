import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app_utils/app_routes.dart';
import '../controller/user_controller.dart';
import '../helper_widgets/get_image.dart';

void bottomSheet({required UserController controller}) => showModalBottomSheet(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: Get.context!,
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