import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTaskController extends GetxController {
  Rx optionList = Rx([]);
  Rx selectedDate = Rx(DateTime.now());
  Rx selectedTime = Rx(TimeOfDay);
  Rx stringDate = Rx('');
  Rx stringTime = Rx('');
  Rx map = Rx({});
  RxBool reminder=RxBool(false);
  RxInt dropDownValue=RxInt(0);
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
