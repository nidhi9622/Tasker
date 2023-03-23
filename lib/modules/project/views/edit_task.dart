import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/shared_prefs/shared_prefs.dart';
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

int newId = 0;

class _EditTaskState extends State<EditTask> {
  dynamic status;
  late DataModel dataModel;
  EditTaskController controller = Get.put(EditTaskController());

  setTaskData() async {
    String? projectName = SharedPrefs.getString(SharedPrefs.projects);
    controller.optionList.value = jsonDecode(projectName);
    if (SharedPrefs.containsKey(SharedPrefs.upcomingProjects)) {
      String? upcoming = SharedPrefs.getString(SharedPrefs.upcomingProjects);
      upcomingProjects = jsonDecode(upcoming);
    }
    if (SharedPrefs.containsKey(SharedPrefs.canceledProjects)) {
      String? canceled = SharedPrefs.getString(SharedPrefs.canceledProjects);
      canceledProjects = jsonDecode(canceled);
    }
    if (SharedPrefs.containsKey(SharedPrefs.ongoingProjects)) {
      String? ongoing = SharedPrefs.getString(SharedPrefs.ongoingProjects);
      ongoingProjects = jsonDecode(ongoing);
    }
    if (SharedPrefs.containsKey(SharedPrefs.completedProjects)) {
      String? completed = SharedPrefs.getString(SharedPrefs.completedProjects);
      completedProjects = jsonDecode(completed);
    }

    if (controller.percentageController.value.text.isEmpty) {
      controller.percentageController.value.text = '0';
    }
    double newPercentage = double.parse(controller.percentageController.value.text);
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
    SharedPrefs.setString(SharedPrefs.projects, jsonEncode(controller.optionList.value));

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
          SharedPrefs.setString(SharedPrefs.canceledProjects, jsonEncode(canceledProjects));
          SharedPrefs.setString(SharedPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          SharedPrefs.setString(SharedPrefs.completedProjects, jsonEncode(completedProjects));
          SharedPrefs.setString(SharedPrefs.ongoingProjects, jsonEncode(ongoingProjects));
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
          if (SharedPrefs.containsKey('${widget.object['title']}')) {
            String? string = SharedPrefs.getString('${widget.object['title']}');
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
          SharedPrefs.setString(SharedPrefs.canceledProjects, jsonEncode(canceledProjects));
          SharedPrefs.setString(SharedPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          SharedPrefs.setString(SharedPrefs.completedProjects, jsonEncode(completedProjects));
          SharedPrefs.setString(SharedPrefs.ongoingProjects, jsonEncode(ongoingProjects));
          SharedPrefs.setString('${widget.object['title']}', jsonEncode(list));
          SharedPrefs.setString(
              SharedPrefs.projects, jsonEncode(controller.optionList.value));
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
          SharedPrefs.setString(SharedPrefs.canceledProjects, jsonEncode(canceledProjects));
          SharedPrefs.setString(SharedPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          SharedPrefs.setString(SharedPrefs.completedProjects, jsonEncode(completedProjects));
          SharedPrefs.setString(SharedPrefs.ongoingProjects, jsonEncode(ongoingProjects));
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
          SharedPrefs.setString(SharedPrefs.canceledProjects, jsonEncode(canceledProjects));
          SharedPrefs.setString(SharedPrefs.upcomingProjects, jsonEncode(upcomingProjects));
          SharedPrefs.setString(SharedPrefs.completedProjects, jsonEncode(completedProjects));
          SharedPrefs.setString(SharedPrefs.ongoingProjects, jsonEncode(ongoingProjects));
        }
        break;
    }
    if (controller.reminder.value == true) {
      int? id = SharedPrefs.getInt(SharedPrefs.userId);
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
      SharedPrefs.setInt(SharedPrefs.userId, id + 1);
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
        status: status,controller: controller,
      );
}
