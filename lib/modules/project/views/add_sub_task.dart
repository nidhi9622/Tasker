import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/local_notification_service.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../../../database/app_list.dart';
import '../controller/add_st_controller.dart';
import '../helper_methods/title_error_dialog.dart';
import '../helper_widgets/sub_task_body.dart';

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
    if (controller.percentageController.value.text.isEmpty) {
      controller.percentageController.value.text = '0';
    }
    double newPercentage =
        double.parse(controller.percentageController.value.text);
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
    if (GetPrefs.containsKey('${widget.object['title']}')) {
      String? mapString = GetPrefs.getString('${widget.object['title']}');
      List newMap = jsonDecode(mapString);
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
    GetPrefs.setString('${widget.object['title']}', jsonEncode(subTask));
    if (controller.reminder.value == true) {
      int? id = GetPrefs.getInt(GetPrefs.userId);
      LocalNotificationService.showScheduleNotification(
          id: id,
          title: '${widget.object['title']} project',
          body: 'Start your ${controller.titleController.value.text} task now',
          payload: jsonEncode(widget.object),
          scheduleTime: DateTime(
              controller.selectedDate.value.year,
              controller.selectedDate.value.month,
              controller.selectedDate.value.day,
              controller.selectedTime.value.hour,
              controller.selectedTime.value.minute));

      GetPrefs.setInt(GetPrefs.userId, id + 1);
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
            child: SubTaskBody(
              controller: controller,
            ),
          ),
        ),
      );
}
