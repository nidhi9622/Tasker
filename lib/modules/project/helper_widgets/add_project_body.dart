import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/modules/project/helper_widgets/task_body_bottom.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../helper_methods/select_date_time.dart';
import 'date_time_widget.dart';
import 'heading_text.dart';
import 'hide_container.dart';

class AddProjectBody extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController subTitleController;
  final TextEditingController descriptionController;
  final TextEditingController percentageController;
  final bool reminder;
  final int dropdownValue;
  DateTime selectedDate;
  TimeOfDay selectedTime;

  AddProjectBody(
      {Key? key,
      required this.titleController,
      required this.subTitleController,
      required this.descriptionController,
      required this.percentageController,
      required this.reminder,
      required this.dropdownValue,
      required this.selectedDate,
      required this.selectedTime})
      : super(key: key);

  @override
  State<AddProjectBody> createState() => _AddProjectBodyState();
}

class _AddProjectBodyState extends State<AddProjectBody> {
  double titleHeight = 0;
  double subTitleHeight = 0;
  double descriptionHeight = 0;
  double percentageHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingText(text: 'projectDetail'.tr),
          HideContainer(
              onTap: () {
                setState(() {
                  titleHeight = 60;
                });
              },
              text: 'title'.tr),
          if (titleHeight > 0)
            SizedBox(
                height: titleHeight,
                child: ProjectTextField(
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
                    maxLines: 1)),
          HideContainer(
              onTap: () {
                setState(() {
                  subTitleHeight = 60;
                });
              },
              text: 'subTitle'.tr),
          if (subTitleHeight > 0)
            SizedBox(
              height: subTitleHeight,
              child: ProjectTextField(
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
            ),
          const SizedBox(height: 12),
          HeadingText(text: 'startDate'.tr),
          DateTimeWidget(
              onTap: () async {
                final picked = await selectDate(context);
                if (picked != null && picked != widget.selectedDate) {
                  setState(() {
                    widget.selectedDate = picked;
                  });
                }
              },
              text: DateFormat("MMM dd, yyyy").format(widget.selectedDate),
              isDate: true),
          HeadingText(text: 'startTime'.tr),
          DateTimeWidget(
              onTap: () async {
                final picked = await selectTime(context);
                if (picked != null && picked != widget.selectedTime) {
                  setState(() {
                    widget.selectedTime = picked;
                  });
                }
              },
              text: widget.selectedTime.format(context),
              isDate: false),
          HeadingText(text: 'additional'.tr),
          HideContainer(
              onTap: () {
                setState(() {
                  descriptionHeight = 60;
                });
              },
              text: 'description'.tr),
          if (descriptionHeight > 0)
            SizedBox(
              height: descriptionHeight,
              child: ProjectTextField(
                  controller: widget.descriptionController,
                  labelText: 'description'.tr,
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.next,
                  maxLength: 100,
                  validator: (String? value) => null,
                  maxLines: 5),
            ),
          TaskBodyBottom(
            reminder: widget.reminder,
            percentageController: widget.percentageController,
            dropDownValue: widget.dropdownValue,
          ),
        ],
      ),
    );
  }
}
