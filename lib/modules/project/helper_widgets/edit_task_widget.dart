import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../helper_methods/select_date_time.dart';
import 'date_time_widget.dart';
import 'heading_text.dart';

class EditTaskWidget extends StatefulWidget {
  final controller;

  const EditTaskWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  @override
  Widget build(BuildContext context) => Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingText(text: 'taskDetail'.tr),
            ProjectTextField(
                controller: widget.controller.titleController.value,
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
                controller: widget.controller.subTitleController.value,
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
                    datePicked != widget.controller.selectedDate.value) {
                  widget.controller.stringDate.value = DateFormat("MMM dd, yyyy").format(datePicked);
                }
              },
              text: '${widget.controller.stringDate.value}',
              isDate: true,
            ),
            HeadingText(text: 'startTime'.tr),
            DateTimeWidget(
              onTap: () async {
                TimeOfDay? timePicked = await selectTime(context);
                if (timePicked != null &&
                    timePicked != widget.controller.selectedTime.value) {
                  widget.controller.stringTime.value = timePicked.format(context);
                }
              },
              text: '${widget.controller.stringTime.value}',
              isDate: false,
            ),
            HeadingText(text: 'additional'.tr),
            ProjectTextField(
                controller: widget.controller.descriptionController.value,
                labelText: 'description'.tr,
                inputType: TextInputType.name,
                inputAction: TextInputAction.next,
                maxLength: 100,
                validator: (String? value) => null,
                maxLines: 5),
          ],
        );
      });
}
