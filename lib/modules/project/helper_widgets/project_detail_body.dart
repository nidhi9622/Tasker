import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_container.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_left.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_right.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/shared_prefs/shared_prefs.dart';
import '../../../database/app_list.dart';
import '../../../models/data_model.dart';
import '../controller/project_detail_controller.dart';
import 'custom_tab_bar.dart';

class ProjectDetailBody extends StatefulWidget {
  final Map object;

  const ProjectDetailBody({Key? key, required this.object}) : super(key: key);

  @override
  State<ProjectDetailBody> createState() => _ProjectDetailBodyState();
}

class _ProjectDetailBodyState extends State<ProjectDetailBody> {
  late DataModel dataModel;
  ProjectDetailController controller = Get.put(ProjectDetailController());

  getData() async {
    if (SharedPrefs.containsKey('${widget.object['title']} notes')) {
      controller.notes.value =
          SharedPrefs.getString('${widget.object['title']} notes');
    }
    if (SharedPrefs.containsKey('${widget.object['title']}')) {
      String? subTask = SharedPrefs.getString('${widget.object['title']}');
      controller.subTaskProjects.value = jsonDecode(subTask);
    }
    if (SharedPrefs.containsKey(SharedPrefs.ongoingProjects)) {
      String? ongoing = SharedPrefs.getString(SharedPrefs.ongoingProjects);
      ongoingProjects = jsonDecode(ongoing);
    }
    if (SharedPrefs.containsKey(SharedPrefs.upcomingProjects)) {
      String? upcoming = SharedPrefs.getString(SharedPrefs.upcomingProjects);
      upcomingProjects = jsonDecode(upcoming);
    }
    if (SharedPrefs.containsKey(SharedPrefs.canceledProjects)) {
      String? cancel = SharedPrefs.getString(SharedPrefs.canceledProjects);
      canceledProjects = jsonDecode(cancel);
    }
    if (SharedPrefs.containsKey(SharedPrefs.completedProjects)) {
      String? completed = SharedPrefs.getString(SharedPrefs.completedProjects);
      completedProjects = jsonDecode(completed);
    }

    if (SharedPrefs.containsKey('${widget.object['title']}')) {
      String? subtask = SharedPrefs.getString('${widget.object['title']}');
      controller.subTaskList.value = jsonDecode(subtask);
      for (int i = 0; i < controller.subTaskList.value.length; i++) {
        controller.totalPercentage.value +=
            controller.subTaskList.value[i]['percentage'];
      }
      // controller.totalPercentage.value = (controller.totalPercentage.value /
      //         controller.subTaskList.value.length);
      String? projectName = SharedPrefs.getString(SharedPrefs.projects);
      controller.optionList.value = jsonDecode(projectName);
      controller.map.value = {
        'title': dataModel.title,
        'subTitle': dataModel.subtitle,
        'description': dataModel.description,
        'percentage': controller.totalPercentage.value,
        'date': dataModel.date,
        'reminder': dataModel.reminder,
        'time': dataModel.time,
        'status': dataModel.status,
      };

      controller.optionList.value[controller.optionList.value
              .indexWhere((element) => element['title'] == dataModel.title)] =
          controller.map.value;
      SharedPrefs.setString(
          SharedPrefs.projects, jsonEncode(controller.optionList.value));
      if (dataModel.status == 'Ongoing') {
        // ongoingProjects.removeWhere((element) => element['title'] ==dataModel.title);
        // ongoingProjects.add(map);
        ongoingProjects[ongoingProjects
                .indexWhere((element) => element['title'] == dataModel.title)] =
            controller.map.value;
        SharedPrefs.setString(
            SharedPrefs.ongoingProjects, jsonEncode(ongoingProjects));
      }
      if (controller.map.value['status'] == 'Upcoming') {
        upcomingProjects[upcomingProjects
                .indexWhere((element) => element['title'] == dataModel.title)] =
            controller.map.value;
        SharedPrefs.setString(
            SharedPrefs.upcomingProjects, jsonEncode(upcomingProjects));
      }
      if (controller.map.value['status'] == 'Canceled') {
        canceledProjects[canceledProjects
                .indexWhere((element) => element['title'] == dataModel.title)] =
            controller.map.value;
        SharedPrefs.setString(
            SharedPrefs.canceledProjects, jsonEncode(canceledProjects));
      }
      if (controller.map.value['status'] == 'Complete') {
        completedProjects[completedProjects
                .indexWhere((element) => element['title'] == dataModel.title)] =
            controller.map.value;
        SharedPrefs.setString(
            SharedPrefs.completedProjects, jsonEncode(completedProjects));
      }
    } else {
      controller.totalPercentage.value = widget.object['percentage'];
    }
  }

  @override
  initState() {
    dataModel = DataModel(widget.object);
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(child: Obx(() {
        return Column(
          children: [
            ProjectDetailContainer(
              object: widget.object,
              totalPercentage: controller.totalPercentage.value,
              dataModel: dataModel,
            ),
            CustomTabBar(
              tabList: detailedPageTab,
              displayIndex: controller.displayIndex,
            ),
            if (controller.displayIndex.value == 0)
              ProjectDetailLeft(
                  object: widget.object,
                  subTaskList: controller.subTaskList.value,
                  subTaskProjects: controller.subTaskProjects.value),
            if (controller.displayIndex.value == 1)
              ProjectDetailRight(
                object: widget.object,
                notesController: controller.notesController.value,
              )
          ],
        );
      }));
}
