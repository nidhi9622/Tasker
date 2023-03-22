import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubTaskController extends GetxController {
  Rx selectedDate = Rx(DateTime.now());
  Rx stringDate = Rx('');
  Rx stringTime = Rx('');
  Rx selectedTime =
      Rx(TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
  Rx<List> subTaskProjects = Rx([]);
  Rx<Map> map = Rx({});
  RxBool reminder = RxBool(false);
  RxInt dropDownValue = RxInt(0);
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
