import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotePad extends StatefulWidget {
  const NotePad({Key? key}) : super(key: key);

  @override
  State<NotePad> createState() => _NotePadState();
}

class _NotePadState extends State<NotePad> {
  late TextEditingController notesController;
  String notes = '';

  @override
  void initState() {
    notesController = TextEditingController(text: notes);
    super.initState();
  }
  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
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
        child: TextField(
          controller: notesController,
          style: const TextStyle(fontSize: 20),
          onChanged: (value) {
            setState(() {
              notes = notesController.text;
            });
          },
          maxLength: null,
          maxLines: null,
          expands: true,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'addNotes'.tr,
              hintStyle: const TextStyle(fontSize: 25)),
        ),
      ),
    );
}
