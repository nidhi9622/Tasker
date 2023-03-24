import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/project_status.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../../../database/app_list.dart';
import '../controller/add_project_controller.dart';
import 'heading_text.dart';

class TaskBodyBottom extends StatefulWidget {
  final AddProjectController controller;

  const TaskBodyBottom({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<TaskBodyBottom> createState() => _TaskBodyBottomState();
}

class _TaskBodyBottomState extends State<TaskBodyBottom> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          const SizedBox(height: 12),
          Container(
              color: Theme.of(context).primaryColor,
              width: double.infinity,
              padding: const EdgeInsets.all(
                14,
              ),
              child: Row(
                children: [
                  Text(
                    'status'.tr,
                    style: const TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 100,
                    child: FormField(builder: (state) {
                      return DropdownButtonFormField(
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        hint: Text(dropdownOptions[0]),
                        items: [
                          for (int i = 0; i < dropdownOptions.length; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text(dropdownOptions[i]),
                            ),
                        ],
                        onChanged: (int? value) {
                          widget.controller.dropDownValue.value = value!;
                          switch(value){
                            case 0:
                              widget.controller.dropdownText.value=ProjectStatus.ongoing;
                              break;
                            case 1:
                              widget.controller.dropdownText.value=ProjectStatus.completed;
                              break;
                            case 2:
                              widget.controller.dropdownText.value=ProjectStatus.upcoming;
                              break;
                            case 3:
                              widget.controller.dropdownText.value=ProjectStatus.canceled;
                              break;
                          }
                        },
                      );
                    }),
                  ),
                ],
              )),
          const SizedBox(height: 15),
          Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.only(
              left: 14,
            ),
            child: Row(
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: widget.controller.reminder.value,
                    onChanged: (value) {
                      widget.controller.reminder.value
                          ? widget.controller.reminder.value = false
                          : widget.controller.reminder.value = true;
                    },
                    fillColor: MaterialStateProperty.all(Colors.red[200]),
                  ),
                ),
                Text('reminder'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          HeadingText(text: 'percentage'.tr),
          ProjectTextField(
              controller: widget.controller.percentageController.value,
              labelText: 'percentage'.tr,
              inputType: TextInputType.name,
              inputAction: TextInputAction.next,
              maxLength: 3,
              validator: (String? value) => null,
              maxLines: 1),
          const SizedBox(height: 25),
        ],
      );
    });
  }
}
