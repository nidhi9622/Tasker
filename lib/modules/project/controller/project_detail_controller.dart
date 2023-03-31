import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProjectDetailController extends GetxController {
  Rx<List> subTaskList = Rx([]);
  Rx<List> optionList = Rx([]);
  Rx<List> subTaskProjects = Rx([]);
  Rx<List> searchShortcut = Rx([]);
  Rx<Map> map = Rx({});
  Rx<List> projectList = Rx([]);
  RxBool reminder = RxBool(false);
  RxBool isAdded = RxBool(false);
  RxInt displayIndex = RxInt(0);
  RxDouble totalPercentage = RxDouble(0.0);
  RxString notes = RxString('');
  RxDouble containerWidth = RxDouble(0.70);
  Rx<TextEditingController> notesController = Rx(TextEditingController());
  Rx<TextEditingController> shortcutController = Rx(TextEditingController());

  @override
  void dispose() {
    notesController.value.dispose();
    super.dispose();
  }
}
