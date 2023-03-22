import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../helper_methods/select_date_time.dart';
import 'date_time_widget.dart';
import 'heading_text.dart';

class EditTaskWidget extends StatefulWidget {
  ValueNotifier stringDate;
  ValueNotifier selectedDate;
  ValueNotifier selectedTime;
  ValueNotifier stringTime;
  final TextEditingController titleController;
  final TextEditingController subTitleController;
  final TextEditingController descriptionController;

  EditTaskWidget(
      {Key? key,
      required this.titleController,
      required this.selectedDate,
      required this.stringDate,
      required this.stringTime,
      required this.selectedTime,
      required this.subTitleController,
      required this.descriptionController})
      : super(key: key);

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: widget.selectedDate,
        builder: (context, value, child) {
          return ValueListenableBuilder(
              valueListenable: widget.stringDate,
              builder: (context, value, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingText(text: 'taskDetail'.tr),
                    ProjectTextField(
                        controller: widget.titleController,
                        labelText: 'title'.tr,
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        maxLength: 30,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'titleError'.tr;
                          }
                          return null;
                        },
                        maxLines: 1),
                    ProjectTextField(
                        controller: widget.subTitleController,
                        labelText: 'subTitle'.tr,
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        maxLength: 30,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'subTitleError'.tr;
                          }
                          return null;
                        },
                        maxLines: 1),
                    const SizedBox(height: 12),
                    HeadingText(text: 'startDate'.tr),
                    DateTimeWidget(
                      onTap: () async {
                        DateTime? datePicked = await selectDate(context);
                        if (datePicked != null &&
                            datePicked != widget.selectedDate.value) {
                          widget.stringDate.value = datePicked;
                          widget.selectedDate.value =
                              DateFormat("MMM dd, yyyy").format(datePicked);
                        }
                      },
                      text: '${widget.selectedDate.value}',
                      isDate: true,
                    ),
                    HeadingText(text: 'startTime'.tr),
                    DateTimeWidget(
                      onTap: () async {
                        TimeOfDay? timePicked = await selectTime(context);
                        if (timePicked != null &&
                            timePicked != widget.selectedTime.value) {
                          setState(() {
                            widget.selectedTime.value =
                                timePicked.format(context);
                            widget.stringTime.value = timePicked;
                          });
                        }
                      },
                      text: '${widget.selectedTime.value}',
                      isDate: false,
                    ),
                    HeadingText(text: 'additional'.tr),
                    ProjectTextField(
                        controller: widget.descriptionController,
                        labelText: 'description'.tr,
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        maxLength: 100,
                        validator: (String? value) => null,
                        maxLines: 5),
                  ],
                );
              });
        });
}
