import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddSTController extends GetxController {
  Rx selectedDate = Rx(DateTime.now());
  Rx selectedTime = Rx(TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute));
  Rx map = Rx({});
  RxBool reminder=RxBool(false);
  RxInt dropDownValue=RxInt(0);
  RxDouble titleHeight=RxDouble(0);
  RxDouble descriptionHeight=RxDouble(0);
  RxDouble subTitleHeight=RxDouble(0);
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
