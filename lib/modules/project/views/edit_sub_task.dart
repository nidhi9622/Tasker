import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/local_notification_service.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../../../database/app_list.dart';
import '../../../models/data_model.dart';
import '../controller/sub_task_controller.dart';
import '../helper_methods/title_error_dialog.dart';
import '../helper_widgets/edit_task_widget.dart';

class EditSubTask extends StatefulWidget {
  final Map object;
  final String title;
  final Map homeObject;

  const EditSubTask(
      {Key? key,
      required this.object,
      required this.title,
      required this.homeObject})
      : super(key: key);

  @override
  State<EditSubTask> createState() => _EditSubTaskState();
}

class _EditSubTaskState extends State<EditSubTask> {
  SubTaskController controller = Get.put(SubTaskController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DataModel dataModel;

  setTaskData() async {
    if (GetPrefs.containsKey(widget.title)) {
      String? subTask = GetPrefs.getString(widget.title);
        controller.subTaskProjects.value = jsonDecode(subTask);
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
      'date': controller.selectedDate.value,
      'reminder': controller.reminder.value,
      'time': controller.selectedTime.value,
      'status': dropdownOptions[controller.dropDownValue.value],
    };
    if (controller.dropDownValue.value == 1) {
      controller.map.value['percentage'] = 100;
      controller.subTaskProjects.value[controller.subTaskProjects.value
              .indexWhere((element) => element['title'] == dataModel.title)] =
          controller.map.value;
    } else {
      controller.subTaskProjects.value[controller.subTaskProjects.value
              .indexWhere((element) => element['title'] == dataModel.title)] =
          controller.map.value;
    }
    GetPrefs.setString(widget.title, jsonEncode(controller.subTaskProjects.value));
    if (controller.reminder.value == true) {
      int? id = GetPrefs.getInt(GetPrefs.userId);
      LocalNotificationService.showScheduleNotification(
          id: id,
          title: 'Reminder',
          body: 'Start your ${controller.titleController.value.text} task now',
          payload: jsonEncode(widget.homeObject),
          scheduleTime: DateTime(
              controller.selectedDate.value.year,
              controller.selectedDate.value.month,
              controller.selectedDate.value.day,
              controller.selectedTime.value.hour,
              controller.selectedTime.value.minute));
      GetPrefs.setInt(GetPrefs.userId, id + 1);
    }
    LocalNotificationService.initialize(
        context: context, object: widget.homeObject);
    await titleErrorDialog(
        context: context, content: 'success'.tr, isTitle: true);
    AppRoutes.go(AppRouteName.projectDetail,
        arguments: {'object': widget.homeObject});
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
    //status = dataModel.status;
    controller.reminder.value = dataModel.reminder??false;
  }

  @override
  initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CommonAppBar(
      text: 'editSubTask'.tr,
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await setTaskData();
        }
      },
      isLeading: true,
      isAction: true,
    ),
    body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: EditTaskWidget(controller: controller),
      ),
    ),
  );
}
