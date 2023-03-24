import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../controller/notepad_controller.dart';

class NotePad extends StatefulWidget {
  const NotePad({Key? key}) : super(key: key);

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  NotepadController controller = Get.put(NotepadController());

  @override
  void initState() {
    super.initState();
  }

  getData() async {
    if (GetPrefs.containsKey(GetPrefs.notepad)) {
      controller.notesController.value =
          TextEditingController(text: GetPrefs.getString(GetPrefs.notepad));
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
                GetPrefs.setString(GetPrefs.notepad, value);
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
