import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProjectController extends GetxController {
  Rx<List> completedProjects = Rx([]);
  Rx<List> optionList = Rx([]);
  Rx<DateTime> selectedDate = Rx(DateTime.now());
  Rx<TimeOfDay> selectedTime =
      Rx(TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
  Rx<List> ongoingProjects = Rx([]);
  Rx<List> projectItem = Rx([]);
  Rx<List> subTaskProjects = Rx([]);
  Rx<List> ongoingTask = Rx([]);
  Rx<List> completedTasks = Rx([]);
  Rx<List> upcomingTasks = Rx([]);
  Rx<List> canceledTasks = Rx([]);
  Rx<Map> map = Rx({});
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
