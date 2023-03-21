import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/dashboard/helper_widgets/process_widget.dart';

import '../../app_utils/global_data.dart';
import '../views/dashboard.dart';

class ProcessWidgetContainer extends StatelessWidget {
  const ProcessWidgetContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: deviceSize.height * 0.27,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).primaryColor),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProcessWidget(
                  text: 'Ongoing'.tr,
                  containerColor: const Color(0xffae74e3),
                  bubbleColor: const Color(0xffdbb9fa),
                  icon: Icons.access_time,
                  object: ongoingProjects),
              ProcessWidget(
                  text: 'Upcoming'.tr,
                  containerColor: const Color(0xfff7b17c),
                  bubbleColor: const Color(0xfffcdec7),
                  icon: CupertinoIcons.timer_fill,
                  object: upcomingProjects),
            ],
          ),
          Row(
            children: [
              ProcessWidget(
                  text: 'Completed'.tr,
                  containerColor: const Color(0xff7cc76d),
                  bubbleColor: const Color(0xffb9faac),
                  icon: CupertinoIcons.check_mark,
                  object: completedProjects),
              ProcessWidget(
                  text: 'Canceled'.tr,
                  containerColor: const Color(0xffff7a92),
                  bubbleColor: const Color(0xfffaacba),
                  icon: CupertinoIcons.clear,
                  object: canceledProjects),
            ],
          ),
        ],
      ),
    );
  }
}
