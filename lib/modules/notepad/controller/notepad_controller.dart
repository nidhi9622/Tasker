import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NotepadController extends GetxController {
  Rx<TextEditingController> notesController = Rx(TextEditingController());

  @override
  void dispose() {
    notesController.value.dispose;
    super.dispose();
  }
}
