import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../../../app_utils/local_notification_service.dart';
import '../../../database/app_list.dart';
import '../controller/add_st_controller.dart';
import '../helper_methods/select_date_time.dart';
import '../helper_methods/title_error_dialog.dart';
import '../helper_widgets/date_time_widget.dart';
import '../helper_widgets/heading_text.dart';
import '../helper_widgets/hide_container.dart';

class AddSubTask extends StatefulWidget {
  final Map object;

  const AddSubTask({Key? key, required this.object}) : super(key: key);

  @override
  State<AddSubTask> createState() => _AddSubTaskState();
}

class _AddSubTaskState extends State<AddSubTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddSTController controller = Get.put(AddSTController());

  setData() async {
    List subTask = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (controller.percentageController.value.text.isEmpty) {
      controller.percentageController.value.text = '0';
    }
    double newPercentage = double.parse(controller.percentageController.value.text);
    String date =
        DateFormat("MMM dd, yyyy").format(controller.selectedDate.value);
    String time = controller.selectedTime.value.format(context);
    controller.map.value = {
      'title': controller.titleController.value.text,
      'subTitle': controller.subTitleController.value.text,
      'description': controller.descriptionController.value.text,
      'percentage': newPercentage,
      'date': date,
      'reminder': controller.reminder.value,
      'time': time,
      'status': dropdownOptions[controller.dropDownValue.value],
    };
    if (preferences.containsKey('${widget.object['title']}')) {
      String? mapString = preferences.getString('${widget.object['title']}');
      List newMap = jsonDecode(mapString!);
      for (int i = 0; i < newMap.length; i++) {
        subTask.add(newMap[i]);
      }
      if (controller.dropDownValue.value == 1) {
        controller.map.value['percentage'] = 100;
        subTask.add(controller.map.value);
      } else {
        subTask.add(controller.map.value);
      }
    } else {
      if (controller.dropDownValue.value == 1) {
        controller.map.value['percentage'] = 100;
        subTask.add(controller.map.value);
      } else {
        subTask.add(controller.map.value);
      }
    }
    preferences.setString('${widget.object['title']}', jsonEncode(subTask));
    if (controller.reminder.value == true) {
      int? id = preferences.getInt('id');
      LocalNotificationService.showScheduleNotification(
          id: id!,
          title: '${widget.object['title']} project',
          body: 'Start your ${controller.titleController.value.text} task now',
          payload: jsonEncode(widget.object),
          scheduleTime: DateTime(
              controller.selectedDate.value.year,
              controller.selectedDate.value.month,
              controller.selectedDate.value.day,
              controller.selectedTime.value.hour,
              controller.selectedTime.value.minute));

      preferences.setInt('id', id + 1);
    }
    LocalNotificationService.initialize(
        context: context, object: widget.object);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CommonAppBar(
          text: 'addTask'.tr,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              if (controller.titleController.value.text.isEmpty ||
                  controller.subTitleController.value.text.isEmpty) {
                await titleErrorDialog(
                    context: context, content: 'error'.tr, isTitle: true);
              } else {
                await titleErrorDialog(
                    context: context, content: 'success'.tr, isTitle: true);
                await setData();
                AppRoutes.go(AppRouteName.projectDetail,
                    arguments: {'object': widget.object});
              }
            }
          },
          isLeading: true,
          isAction: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
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
                          if (picked != null &&
                              picked != controller.selectedDate.value) {
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
                          if (picked != null &&
                              picked != controller.selectedTime.value) {
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
                }
              ),
            ),
          ),
        ),
      );
}
