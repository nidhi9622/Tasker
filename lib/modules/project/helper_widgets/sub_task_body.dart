import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../controller/add_st_controller.dart';
import '../helper_methods/select_date_time.dart';
import 'date_time_widget.dart';
import 'heading_text.dart';
import 'hide_container.dart';

class SubTaskBody extends StatefulWidget {
  final AddSTController controller;

  const SubTaskBody({Key? key, required this.controller}) : super(key: key);

  @override
  State<SubTaskBody> createState() => _SubTaskBodyState();
}

class _SubTaskBodyState extends State<SubTaskBody> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(0),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(text: 'taskDetail'.tr),
                HideContainer(
                    onTap: () => widget.controller.titleHeight.value = 60,
                    text: 'title'.tr),
                if (widget.controller.titleHeight.value > 0)
                  SizedBox(
                      height: widget.controller.titleHeight.value,
                      child: ProjectTextField(
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
                          maxLines: 1)),
                HideContainer(
                    onTap: () => widget.controller.subTitleHeight.value = 60,
                    text: 'subTitle'.tr),
                if (widget.controller.subTitleHeight.value > 0)
                  SizedBox(
                    height: widget.controller.subTitleHeight.value,
                    child: ProjectTextField(
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
                  ),
                const SizedBox(height: 8),
                HeadingText(text: 'startDate'.tr),
                DateTimeWidget(
                  onTap: () async {
                    DateTime? picked = await selectDate(context);
                    if (picked != null &&
                        picked != widget.controller.selectedDate.value) {
                      widget.controller.selectedDate.value = picked;
                    }
                  },
                  text: DateFormat("MMM dd, yyyy")
                      .format(widget.controller.selectedDate.value),
                  isDate: true,
                ),
                const SizedBox(height: 8),
                HeadingText(text: 'startTime'.tr),
                DateTimeWidget(
                  onTap: () async {
                    final picked = await selectTime(context);
                    if (picked != null &&
                        picked != widget.controller.selectedTime.value) {
                      widget.controller.selectedTime.value = picked;
                    }
                  },
                  text:
                      '${widget.controller.selectedTime.value.format(context)}',
                  isDate: false,
                ),
                const SizedBox(
                  height: 5,
                ),
                HeadingText(text: 'additional'.tr),
                HideContainer(
                    onTap: () =>
                        widget.controller.descriptionHeight.value = 120,
                    text: 'description'.tr),
                if (widget.controller.descriptionHeight.value > 0)
                  ProjectTextField(
                      controller: widget.controller.descriptionController.value,
                      labelText: 'description'.tr,
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      maxLength: 100,
                      validator: (String? value) => null,
                      maxLines: 5),
              ],
            )),
      );
}
