import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/global_data.dart';
import 'package:task_manager/app_utils/project_status.dart';
import 'package:task_manager/app_utils/shared_prefs/get_prefs.dart';
import '../../../app_utils/app_routes.dart';
import '../../../services/local_notification_service.dart';
import '../../../database/app_list.dart';
import '../../../models/data_model.dart';
import '../controller/edit_task_controller.dart';
import '../helper_methods/title_error_dialog.dart';
import '../helper_widgets/edit_task_body.dart';

class EditProject extends StatefulWidget {
  final Map<String, dynamic> object;

  const EditProject({Key? key, required this.object}) : super(key: key);

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  dynamic status;
  late DataModel dataModel;
  EditTaskController controller = Get.put(EditTaskController());

  Future<void> setTaskData() async {
    String? projectName = GetPrefs.getString(GetPrefs.projects);
    controller.optionList.value = jsonDecode(projectName);

    if (controller.percentageController.value.text.isEmpty) {
      controller.percentageController.value.text = '0';
    }
    double newPercentage =
        double.parse(controller.percentageController.value.text);
    controller.map.value = {
      'title': controller.titleController.value.text,
      'subTitle': controller.subTitleController.value.text,
      'description': controller.descriptionController.value.text,
      'percentage':
          controller.dropdownText.value == "${ProjectStatus.completed}"
              ? 100.0
              : newPercentage,
      'date': controller.stringDate.value,
      'reminder': controller.reminder.value,
      'time': controller.stringTime.value,
      'status': dropdownOptions[controller.dropDownValue.value],
      'projectStatus': controller.dropdownText.value,
      'id': dataModel.id
    };
    controller.optionList.value[controller.optionList.value
            .indexWhere((element) => element['title'] == dataModel.title)] =
        controller.map;
    GetPrefs.setString(
        GetPrefs.projects, jsonEncode(controller.optionList.value));

    if (controller.reminder.value == true) {
      int? id = GetPrefs.getInt(GetPrefs.userId);
      LocalNotificationService.showScheduleNotification(
          id: id,
          title: 'Reminder',
          body: 'Start your ${controller.titleController.value.text} task now',
          payload: jsonEncode(controller.map),
          scheduleTime: DateTime(
              controller.selectedDate.value.year,
              controller.selectedDate.value.month,
              controller.selectedDate.value.day,
              controller.selectedTime.value.hour,
              controller.selectedTime.value.minute));
      GetPrefs.setInt(GetPrefs.userId, id + 1);
      LocalNotificationService.initialize(
          context: context, object: controller.map);
    }
    await titleErrorDialog(
        context: context, content: 'success'.tr, isTitle: true);
    selectIndex.value = 0;
    AppRoutes.go(AppRouteName.bottomNavPage);
  }

  void setData() {
    dataModel = DataModel.fromJson(widget.object);
    controller.titleController.value =
        TextEditingController(text: dataModel.title);
    controller.subTitleController.value =
        TextEditingController(text: dataModel.subTitle);
    controller.percentageController.value =
        TextEditingController(text: dataModel.percentage.toString());
    controller.descriptionController.value =
        TextEditingController(text: dataModel.description);
    controller.stringDate.value = dataModel.date;
    controller.stringTime.value = dataModel.time;
    controller.dropdownText.value =
        dataModel.projectStatus ?? "${ProjectStatus.ongoing}";
    status = dataModel.status;
    controller.reminder.value = dataModel.reminder ?? false;
  }

  @override
  initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => EditTaskBody(
        setTaskData: setTaskData,
        status: status,
        controller: controller,
      );
}
