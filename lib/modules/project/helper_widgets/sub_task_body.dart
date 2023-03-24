import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../controller/add_st_controller.dart';
import '../helper_methods/select_date_time.dart';
import 'date_time_widget.dart';
import 'heading_text.dart';
import 'hide_container.dart';

class SubTaskBody extends StatelessWidget {
  final AddSTController controller;

  const SubTaskBody({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(text: 'taskDetail'.tr),
            HideContainer(
                onTap: () {
                  controller.titleHeight.value = 60;
                },
                text: 'title'.tr),
            if (controller.titleHeight.value > 0)
              SizedBox(
                  height: controller.titleHeight.value,
                  child: ProjectTextField(
                      controller: controller.titleController.value,
                      labelText: 'title'.tr,
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      maxLength: 30,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'titleError'.tr;
                        }
                        return null;
                      },
                      maxLines: 1)),
            HideContainer(
                onTap: () {
                  controller.subTitleHeight.value = 60;
                },
                text: 'subTitle'.tr),
            if (controller.subTitleHeight.value > 0)
              SizedBox(
                height: controller.subTitleHeight.value,
                child: ProjectTextField(
                    controller: controller.subTitleController.value,
                    labelText: 'subTitle'.tr,
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.next,
                    maxLength: 30,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'subTitleError'.tr;
                      }
                      return null;
                    },
                    maxLines: 1),
              ),
            const SizedBox(height: 8),
            HeadingText(text: 'startDate'.tr),
            DateTimeWidget(
              onTap: () async {
                DateTime? picked = await selectDate(context);
                if (picked != null && picked != controller.selectedDate.value) {
                  controller.selectedDate.value = picked;
                }
              },
              text: DateFormat("MMM dd, yyyy")
                  .format(controller.selectedDate.value),
              isDate: true,
            ),
            const SizedBox(height: 8),
            HeadingText(text: 'startTime'.tr),
            DateTimeWidget(
              onTap: () async {
                final picked = await selectTime(context);
                if (picked != null && picked != controller.selectedTime.value) {
                  controller.selectedTime.value = picked;
                }
              },
              text: '${controller.selectedTime.value.format(context)}',
              isDate: false,
            ),
            const SizedBox(
              height: 5,
            ),
            HeadingText(text: 'additional'.tr),
            HideContainer(
                onTap: () {
                  controller.descriptionHeight.value = 120;
                },
                text: 'description'.tr),
            if (controller.descriptionHeight.value > 0)
              ProjectTextField(
                  controller: controller.descriptionController.value,
                  labelText: 'description'.tr,
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.next,
                  maxLength: 100,
                  validator: (String? value) => null,
                  maxLines: 5),
          ],
        );
      }),
    );
  }
}
