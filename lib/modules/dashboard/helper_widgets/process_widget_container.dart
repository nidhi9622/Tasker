import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/project_status.dart';
import 'package:task_manager/modules/dashboard/helper_widgets/process_widget.dart';

class ProcessWidgetContainer extends StatelessWidget {
  const ProcessWidgetContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        //width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).primaryColor),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ProcessWidget(
                      text: 'Ongoing'.tr,
                      containerColor: const Color(0xffae74e3),
                      bubbleColor: const Color(0xffdbb9fa),
                      icon: Icons.access_time,
                      status: "${ProjectStatus.ongoing}"),
                ),
                Expanded(
                  child: ProcessWidget(
                      text: 'Upcoming'.tr,
                      containerColor: const Color(0xfff7b17c),
                      bubbleColor: const Color(0xfffcdec7),
                      icon: CupertinoIcons.timer_fill,
                      status: "${ProjectStatus.upcoming}"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ProcessWidget(
                      text: 'Completed'.tr,
                      containerColor: const Color(0xff7cc76d),
                      bubbleColor: const Color(0xffb9faac),
                      icon: CupertinoIcons.check_mark,
                      status: "${ProjectStatus.completed}"),
                ),
                Expanded(
                  child: ProcessWidget(
                      text: 'Canceled'.tr,
                      containerColor: const Color(0xffff7a92),
                      bubbleColor: const Color(0xfffaacba),
                      icon: CupertinoIcons.clear,
                      status: "${ProjectStatus.canceled}"),
                ),
              ],
            ),
          ],
        ),
      );
}
