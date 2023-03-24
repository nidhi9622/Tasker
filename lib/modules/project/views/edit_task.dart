import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/shared_prefs/get_prefs.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/local_notification_service.dart';
import '../../../database/app_list.dart';
import '../../../models/data_model.dart';
import '../controller/edit_task_controller.dart';
import '../helper_methods/title_error_dialog.dart';
import '../helper_widgets/edit_task_body.dart';

class EditTask extends StatefulWidget {
  final Map object;

  const EditTask({Key? key, required this.object}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  dynamic status;
  late DataModel dataModel;
  EditTaskController controller = Get.put(EditTaskController());

  setTaskData() async {
    String? projectName = GetPrefs.getString(GetPrefs.projects);
    controller.optionList.value = jsonDecode(projectName);
    if (GetPrefs.containsKey(GetPrefs.upcomingProjects)) {
      String? upcoming = GetPrefs.getString(GetPrefs.upcomingProjects);
      upcomingProjects = jsonDecode(upcoming);
    }
    if (GetPrefs.containsKey(GetPrefs.canceledProjects)) {
      String? canceled = GetPrefs.getString(GetPrefs.canceledProjects);
      canceledProjects = jsonDecode(canceled);
    }
    if (GetPrefs.containsKey(GetPrefs.ongoingProjects)) {
      String? ongoing = GetPrefs.getString(GetPrefs.ongoingProjects);
      ongoingProjects = jsonDecode(ongoing);
    }
    if (GetPrefs.containsKey(GetPrefs.completedProjects)) {
      String? completed = GetPrefs.getString(GetPrefs.completedProjects);
      completedProjects = jsonDecode(completed);
    }

    if (controller.percentageController.value.text.isEmpty) {
      controller.percentageController.value.text = '0';
    }
    double newPercentage =
        double.parse(controller.percentageController.value.text);
    controller.map.value = {
      'title': controller.titleController.value.text,
      'subTitle': controller.subTitleController.value.text,
      'description': controller.descriptionController.value.text,
      'percentage': newPercentage,
      'date': controller.stringDate.value,
      'reminder': controller.reminder.value,
      'time': controller.stringTime.value,
      'status': dropdownOptions[controller.dropDownValue.value],
    };
    controller.optionList.value[controller.optionList.value
            .indexWhere((element) => element['title'] == dataModel.title)] =
        controller.map.value;
    GetPrefs.setString(
        GetPrefs.projects, jsonEncode(controller.optionList.value));

    switch (controller.dropDownValue.value) {
      case 0:
        {
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects.add(controller.map.value);
          GetPrefs.setString(
              GetPrefs.canceledProjects, jsonEncode(canceledProjects));
          GetPrefs.setString(
              GetPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          GetPrefs.setString(
              GetPrefs.completedProjects, jsonEncode(completedProjects));
          GetPrefs.setString(
              GetPrefs.ongoingProjects, jsonEncode(ongoingProjects));
        }
        break;
      case 1:
        {
          List list = [];
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          if (GetPrefs.containsKey('${widget.object['title']}')) {
            String? string = GetPrefs.getString('${widget.object['title']}');
            list = jsonDecode(string);
            for (int i = 0; i < list.length; i++) {
              list[i]['percentage'] = 100;
            }
          } else {
            controller.map.value['percentage'] = 100;
            controller.optionList.value[controller.optionList.value.indexWhere(
                    (element) => element['title'] == dataModel.title)] =
                controller.map.value;
          }
          completedProjects.add(controller.map.value);
          GetPrefs.setString(
              GetPrefs.canceledProjects, jsonEncode(canceledProjects));
          GetPrefs.setString(
              GetPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          GetPrefs.setString(
              GetPrefs.completedProjects, jsonEncode(completedProjects));
          GetPrefs.setString(
              GetPrefs.ongoingProjects, jsonEncode(ongoingProjects));
          GetPrefs.setString('${widget.object['title']}', jsonEncode(list));
          GetPrefs.setString(
              GetPrefs.projects, jsonEncode(controller.optionList.value));
        }
        break;
      case 2:
        {
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          upcomingProjects.add(controller.map.value);
          GetPrefs.setString(
              GetPrefs.canceledProjects, jsonEncode(canceledProjects));
          GetPrefs.setString(
              GetPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          GetPrefs.setString(
              GetPrefs.completedProjects, jsonEncode(completedProjects));
          GetPrefs.setString(
              GetPrefs.ongoingProjects, jsonEncode(ongoingProjects));
        }
        break;
      case 3:
        {
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects.add(controller.map.value);
          GetPrefs.setString(
              GetPrefs.canceledProjects, jsonEncode(canceledProjects));
          GetPrefs.setString(
              GetPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          GetPrefs.setString(
              GetPrefs.completedProjects, jsonEncode(completedProjects));
          GetPrefs.setString(
              GetPrefs.ongoingProjects, jsonEncode(ongoingProjects));
        }
        break;
    }
    if (controller.reminder.value == true) {
      int? id = GetPrefs.getInt(GetPrefs.userId);
      LocalNotificationService.showScheduleNotification(
          id: id,
          title: 'Reminder',
          body: 'Start your ${controller.titleController.value.text} task now',
          payload: jsonEncode(controller.map.value),
          scheduleTime: DateTime(
              controller.selectedDate.value.year,
              controller.selectedDate.value.month,
              controller.selectedDate.value.day,
              controller.selectedTime.value.hour,
              controller.selectedTime.value.minute));
      GetPrefs.setInt(GetPrefs.userId, id + 1);
      LocalNotificationService.initialize(
          context: context, object: controller.map.value);
    }
    await titleErrorDialog(
        context: context, content: 'success'.tr, isTitle: true);
    AppRoutes.go(AppRouteName.homePage);
  }

  setData() {
    dataModel = DataModel(widget.object);
    controller.titleController.value =
        TextEditingController(text: dataModel.title);
    controller.subTitleController.value =
        TextEditingController(text: dataModel.subtitle);
    controller.percentageController.value =
        TextEditingController(text: dataModel.percentage.toString());
    controller.descriptionController.value =
        TextEditingController(text: dataModel.description);
    controller.stringDate.value = dataModel.date;
    controller.stringTime.value = dataModel.time;
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
