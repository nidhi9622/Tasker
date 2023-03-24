import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/project_status.dart';

class AddProjectController extends GetxController {
  Rx<DateTime> selectedDate = Rx(DateTime.now());
  Rx<TimeOfDay> selectedTime =
      Rx(TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
  Rx<List> ongoingTask = Rx([]);
  Rx<List> completedTasks = Rx([]);
  Rx<List> upcomingTasks = Rx([]);
  Rx<List> canceledTasks = Rx([]);
  RxMap<String,dynamic> map = RxMap({});
  Rx<String> dropdownText = Rx("${ProjectStatus.ongoing}");
  RxBool reminder = RxBool(false);
  RxBool preExist = RxBool(false);
  RxInt dropDownValue = RxInt(0);
  RxDouble titleHeight = RxDouble(0);
  RxDouble descriptionHeight = RxDouble(0);
  RxDouble subTitleHeight = RxDouble(0);
  Rx<TextEditingController> titleController = Rx(TextEditingController());
  Rx<TextEditingController> subTitleController = Rx(TextEditingController());
  Rx<TextEditingController> percentageController = Rx(TextEditingController());
  Rx<TextEditingController> descriptionController = Rx(TextEditingController());

  @override
  void dispose() {
    titleController.value.dispose();
    subTitleController.value.dispose();
    descriptionController.value.dispose();
    percentageController.value.dispose();
    super.dispose();
  }
}
