import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/notepad_controller.dart';

class NotePad extends StatefulWidget {
  const NotePad({Key? key}) : super(key: key);

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  late SharedPreferences preferences;
  NotepadController controller = Get.put(NotepadController());

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('notepad')) {
      controller.notesController.value =
          TextEditingController(text: preferences.getString('notepad'));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'notepad'.tr,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Obx(() {
            return TextField(
              controller: controller.notesController.value,
              style: const TextStyle(fontSize: 20),
              onChanged: (value) async {
                await preferences.setString('notepad', value);
              },
              maxLength: null,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'addNotes'.tr,
                  hintStyle: const TextStyle(fontSize: 25)),
            );
          }),
        ),
      );
}
