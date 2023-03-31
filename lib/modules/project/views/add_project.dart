import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import 'package:task_manager/app_utils/shared_prefs/get_prefs.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../../../services/local_notification_service.dart';
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
List newList=[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      newList = jsonDecode(map);
    }
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
    double newPercentage =
        double.parse(controller.percentageController.value.text);
    String date =
        DateFormat("MMM dd, yyyy").format(controller.selectedDate.value);
    String time = controller.selectedTime.value.format(context);
    var map= {
      'title': controller.titleController.value.text,
      'subTitle': controller.subTitleController.value.text,
      'description': controller.descriptionController.value.text,
      'percentage': newPercentage,
      'date': date,
      'reminder': controller.reminder.value,
      'time': time,
      'status': dropdownOptions[controller.dropDownValue.value],
      'projectStatus': controller.dropdownText.value,
      'id': newList.length
    };

    String? mapString;
    List projectList = [];
    List newMap;
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      mapString = GetPrefs.getString(GetPrefs.projects);
      newMap = jsonDecode(mapString);
      for (int i = 0; i < newMap.length; i++) {
        projectList.add(newMap[i]);
      }
      projectList.add(map);
    } else {
      //projectList.add(controller.map.value);
      projectList.add(map);
    }
    GetPrefs.setString(GetPrefs.projects, jsonEncode(projectList));
    if (controller.reminder.value) {
      int? id = GetPrefs.getInt(GetPrefs.userId);
      LocalNotificationService.showScheduleNotification(
          id: id,
          title: 'Reminder',
          body: 'Start your ${controller.titleController.value.text} task now',
          payload: jsonEncode(map),
          scheduleTime: DateTime(
              controller.selectedDate.value.year,
              controller.selectedDate.value.month,
              controller.selectedDate.value.day,
              controller.selectedTime.value.hour,
              controller.selectedTime.value.minute));

      GetPrefs.setInt(GetPrefs.userId, id + 1);
    }
    // ignore: use_build_context_synchronously
    LocalNotificationService.initialize(
        context: context, object: map);
    // ignore: use_build_context_synchronously
    await titleErrorDialog(
        context: context, content: 'success'.tr, isTitle: true);
    selectIndex.value = 0;
    AppRoutes.pushAndRemoveUntil(AppRouteName.bottomNavPage);
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
