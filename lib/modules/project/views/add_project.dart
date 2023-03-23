import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/local_notification_service.dart';
import '../../../database/app_list.dart';
import '../controller/add_project_controller.dart';
import '../helper_methods/title_error_dialog.dart';
import '../helper_widgets/add_project_body.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  AddProjectController controller = Get.put(AddProjectController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.titleHeight.value = 0;
    controller.subTitleHeight.value = 0;
    controller.descriptionHeight.value = 0;
    controller.percentageController.value.text = '';
    controller.descriptionController.value.text = '';
    controller.titleController.value.text = '';
    controller.subTitleController.value.text = '';
    super.initState();
  }

  setData() async {
    if (controller.percentageController.value.text.isEmpty) {
      controller.percentageController.value.text = '0';
    }
    double newPercentage = double.parse(controller.percentageController.value.text);
    String date =
        DateFormat("MMM dd, yyyy").format(controller.selectedDate.value);
    String time = controller.selectedTime.value.format(context);
    for (int i = 0; i < projectItem.length; i++) {}
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

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? mapString;
    List projectList = [];
    List newMap;
    if (preferences.containsKey('projects')) {
      mapString = preferences.getString('projects');
      newMap = jsonDecode(mapString!);
      for (int i = 0; i < newMap.length; i++) {
        if (controller.titleController.value.text.removeAllWhitespace ==
            newMap[i]['title']) {
          controller.preExist.value = true;
        } else {
          controller.preExist.value = false;
        }
      }
    }
    if (controller.preExist.value == true) {
      // ignore: use_build_context_synchronously
      titleErrorDialog(
          context: context,
          content:
              'Project with this title already exist.\nPlease try with another title.',
          isTitle: false);
    } else {
      if (preferences.containsKey('projects')) {
        mapString = preferences.getString('projects');
        newMap = jsonDecode(mapString!);
        for (int i = 0; i < newMap.length; i++) {
          //print('title is : ${newMap[i]['title']}');
          projectList.add(newMap[i]);
        }
        projectList.add(controller.map.value);
      } else {
        projectList.add(controller.map.value);
      }
      preferences.setString('projects', jsonEncode(projectList));
      switch (controller.dropDownValue.value) {
        case 0:
          {
            String? mapStringOnGoing;
            List newMapOngoing;
            if (preferences.containsKey('ongoingProjects')) {
              mapStringOnGoing = preferences.getString('ongoingProjects');
              newMapOngoing = jsonDecode(mapStringOnGoing!);
              for (int i = 0; i < newMapOngoing.length; i++) {
                controller.ongoingTask.value.add(newMapOngoing[i]);
              }
              controller.ongoingTask.value.add(controller.map.value);
            } else {
              controller.ongoingTask.value.add(controller.map.value);
            }
            String totalProjects = jsonEncode(controller.ongoingTask.value);
            preferences.setString('ongoingProjects', totalProjects);
          }
          break;
        case 1:
          {
            String? mapStringCompleted;
            List newMapCompleted;
            if (preferences.containsKey('completedProjects')) {
              mapStringCompleted = preferences.getString('completedProjects');
              newMapCompleted = jsonDecode(mapStringCompleted!);
              for (int i = 0; i < newMapCompleted.length; i++) {
                controller.completedTasks.value.add(newMapCompleted[i]);
              }
              controller.map.value['percentage'] = 100;
              controller.completedTasks.value.add(controller.map.value);
            } else {
              controller.map.value['percentage'] = 100;
              controller.completedTasks.value.add(controller.map.value);
              projectList[projectList.indexWhere((element) =>
                      element['title'] ==
                      controller.titleController.value.text)] =
                  controller.map.value;
            }
            preferences.setString('completedProjects',
                jsonEncode(controller.completedTasks.value));
            preferences.setString('projects', jsonEncode(projectList));
          }
          break;
        case 2:
          {
            String? mapStringUpcoming;
            List newMapUpcoming;
            if (preferences.containsKey('upcomingProjects')) {
              mapStringUpcoming = preferences.getString('upcomingProjects');
              newMapUpcoming = jsonDecode(mapStringUpcoming!);
              for (int i = 0; i < newMapUpcoming.length; i++) {
                controller.upcomingTasks.value.add(newMapUpcoming[i]);
              }
              controller.upcomingTasks.value.add(controller.map.value);
            } else {
              controller.upcomingTasks.value.add(controller.map.value);
            }
            String totalProjects = jsonEncode(controller.upcomingTasks.value);

            preferences.setString('upcomingProjects', totalProjects);
          }
          break;
        case 3:
          {
            String? mapStringCanceled;
            List newMapCanceled;
            if (preferences.containsKey('canceledProjects')) {
              mapStringCanceled = preferences.getString('canceledProjects');
              newMapCanceled = jsonDecode(mapStringCanceled!);
              for (int i = 0; i < newMapCanceled.length; i++) {
                controller.canceledTasks.value.add(newMapCanceled[i]);
              }
              controller.canceledTasks.value.add(controller.map.value);
            } else {
              controller.canceledTasks.value.add(controller.map.value);
            }
            String totalProjects = jsonEncode(controller.canceledTasks.value);

            preferences.setString('canceledProjects', totalProjects);
          }
          break;
      }
      if (controller.reminder.value) {
        int? id = preferences.getInt('id');
        LocalNotificationService.showScheduleNotification(
            id: id!,
            title: 'Reminder',
            body:
                'Start your ${controller.titleController.value.text} task now',
            payload: jsonEncode(controller.map.value),
            scheduleTime: DateTime(
                controller.selectedDate.value.year,
                controller.selectedDate.value.month,
                controller.selectedDate.value.day,
                controller.selectedTime.value.hour,
                controller.selectedTime.value.minute));

        preferences.setInt('id', id + 1);
      }
      // ignore: use_build_context_synchronously
      LocalNotificationService.initialize(
          context: context, object: controller.map.value);
      // ignore: use_build_context_synchronously
      await titleErrorDialog(
          context: context, content: 'success'.tr, isTitle: true);
      selectIndex.value = 0;
      AppRoutes.go(AppRouteName.homePage);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CommonAppBar(
          text: 'newProject'.tr,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              if (controller.titleController.value.text.isEmpty ||
                  controller.subTitleController.value.text.isEmpty) {
                await titleErrorDialog(
                    context: context, content: 'error'.tr, isTitle: true);
              } else {
                await setData();
              }
            }
          },
          isLeading: false,
          isAction: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: AddProjectBody(
              controller: controller,
            ),
          ),
        ),
      );
}
