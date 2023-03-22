import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_utils/common_app_bar.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../../../database/app_list.dart';
import 'edit_task_widget.dart';
import 'heading_text.dart';

class EditTaskBody extends StatefulWidget {
  final ValueNotifier stringDate;
  final ValueNotifier selectedDate;
  final ValueNotifier selectedTime;
  final ValueNotifier stringTime;
  final dynamic setTaskData;
  final TextEditingController percentageController;
  final TextEditingController titleController;
  final TextEditingController subTitleController;
  final TextEditingController descriptionController;
  bool reminder;
  int dropDownValue;
  final String status;

  EditTaskBody(
      {Key? key,
      required this.stringDate,
      required this.selectedDate,
      required this.selectedTime,
      required this.stringTime,
      required this.setTaskData,
      required this.percentageController,
      required this.titleController,
      required this.subTitleController,
      required this.descriptionController,
      required this.reminder,
      required this.dropDownValue,
      required this.status})
      : super(key: key);

  @override
  State<EditTaskBody> createState() => _EditTaskBodyState();
}

class _EditTaskBodyState extends State<EditTaskBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: widget.stringDate,
      builder: (context, value, child) => ValueListenableBuilder(
          valueListenable: widget.selectedDate,
          builder: (context, value, child) => ValueListenableBuilder(
              valueListenable: widget.selectedTime,
              builder: (context, value, child) => ValueListenableBuilder(
                  valueListenable: widget.stringTime,
                  builder: (context, value, child) => Scaffold(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EditTaskWidget(
                                    titleController: widget.titleController,
                                    selectedDate: widget.selectedDate,
                                    stringDate: widget.stringDate,
                                    subTitleController:
                                        widget.subTitleController,
                                    descriptionController:
                                        widget.descriptionController,
                                    stringTime: widget.stringTime,
                                    selectedTime: widget.selectedTime,
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
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Center(
                                              child:
                                                  FormField(builder: (state) {
                                                return DropdownButtonFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  hint: Text(widget.status),
                                                  items: [
                                                    for (int i = 0;
                                                        i <
                                                            dropdownOptions
                                                                .length;
                                                        i++)
                                                      DropdownMenuItem(
                                                        value: i,
                                                        child: Text(
                                                            dropdownOptions[i]),
                                                      ),
                                                  ],
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      widget.dropDownValue =
                                                          value!;
                                                    });
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
                                            value: widget.reminder,
                                            onChanged: (value) {
                                              setState(() {
                                                widget.reminder == true
                                                    ? widget.reminder = false
                                                    : widget.reminder = true;
                                              });
                                            },
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    Colors.red[200]),
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
                                      controller: widget.percentageController,
                                      labelText: 'percentage'.tr,
                                      inputType: TextInputType.number,
                                      inputAction: TextInputAction.done,
                                      maxLength: 3,
                                      validator: (String? value) => null,
                                      maxLines: 1),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )))));
}
