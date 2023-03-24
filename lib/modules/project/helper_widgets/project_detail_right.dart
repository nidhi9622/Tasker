import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';

class ProjectDetailRight extends StatefulWidget {
  final Map object;
  final TextEditingController notesController;

  const ProjectDetailRight(
      {Key? key, required this.object, required this.notesController})
      : super(key: key);

  @override
  State<ProjectDetailRight> createState() => _ProjectDetailRightState();
}

class _ProjectDetailRightState extends State<ProjectDetailRight> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.all(12),
      //height: double.infinity,
      constraints: BoxConstraints(maxHeight: deviceSize.height * 0.378),
      child: TextField(
        controller: widget.notesController,
        style: const TextStyle(fontSize: 20),
        onChanged: (value) async {
          GetPrefs.setString(
              '${widget.object['title']} notes', widget.notesController.text);
        },
        maxLength: null,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'addNotes'.tr,
            hintStyle: const TextStyle(fontSize: 25)),
      ),
    );
  }
}
