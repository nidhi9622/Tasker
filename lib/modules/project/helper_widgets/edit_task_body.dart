import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_utils/common_app_bar.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../../../app_utils/project_status.dart';
import '../../../database/app_list.dart';
import 'edit_task_widget.dart';
import 'heading_text.dart';

class EditTaskBody extends StatefulWidget {
  final dynamic setTaskData;
  final String status;
  final dynamic controller;

  const EditTaskBody(
      {Key? key,
      required this.setTaskData,
      required this.status,
      required this.controller})
      : super(key: key);

  @override
  State<EditTaskBody> createState() => _EditTaskBodyState();
}

class _EditTaskBodyState extends State<EditTaskBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CommonAppBar(
          text: 'editTask'.tr,
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              await widget.setTaskData();
            }
          },
          isLeading: true,
          isAction: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(0),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EditTaskWidget(
                        controller: widget.controller,
                      ),
                      const SizedBox(height: 14),
                      Container(
                          color: Theme.of(context).primaryColor,
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 14, top: 5, bottom: 5),
                          child: Row(
                            children: [
                              Text(
                                'status'.tr,
                                style: const TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: 100,
                                child: Center(
                                  child: FormField(builder: (state) {
                                    return DropdownButtonFormField(
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                      hint: Text(widget.status),
                                      items: [
                                        for (int i = 0;
                                            i < dropdownOptions.length;
                                            i++)
                                          DropdownMenuItem(
                                            value: i,
                                            child: Text(dropdownOptions[i]),
                                          ),
                                      ],
                                      onChanged: (int? value) {
                                        widget.controller.dropDownValue.value =
                                            value!;
                                        switch (value) {
                                          case 0:
                                            widget.controller.dropdownText.value =
                                            "${ProjectStatus.ongoing}";
                                            break;
                                          case 1:
                                            widget.controller.dropdownText.value =
                                            "${ProjectStatus.completed}";
                                            break;
                                          case 2:
                                            widget.controller.dropdownText.value =
                                            "${ProjectStatus.upcoming}";
                                            break;
                                          case 3:
                                            widget.controller.dropdownText.value =
                                            "${ProjectStatus.canceled}";
                                            break;
                                        }
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 13),
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
                                  widget.controller.reminder.value == true
                                      ? widget.controller.reminder.value = false
                                      : widget.controller.reminder.value = true;
                                },
                                fillColor:
                                    MaterialStateProperty.all(Colors.red[200]),
                              ),
                            ),
                            Text('reminder'.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 13),
                      HeadingText(text: 'percentage'.tr),
                      ProjectTextField(
                          controller:
                              widget.controller.percentageController.value,
                          labelText: 'percentage'.tr,
                          inputType: TextInputType.number,
                          inputAction: TextInputAction.done,
                          maxLength: 3,
                          validator: (String? value) => null,
                          maxLines: 1),
                      const SizedBox(height: 25),
                    ],
                  );
                })),
          ),
        ),
      );
}
