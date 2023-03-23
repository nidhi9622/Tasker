import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/default_app_bar.dart';
import '../../../app_utils/shared_prefs/shared_prefs.dart';
import '../../../database/app_list.dart';
import '../../dashboard/helper_methods/search.dart';
import '../controller/project_controller.dart';
import '../helper_methods/sorting_bottom_sheet.dart';
import '../helper_widgets/custom_tab_bar.dart';
import '../helper_widgets/project_tab_view.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  ProjectController controller = Get.put(ProjectController());

  getProjectItem() async {
    if (SharedPrefs.containsKey(SharedPrefs.projects)) {
      var map = SharedPrefs.getString(SharedPrefs.projects);
      controller.projectItem.value = jsonDecode(map);
    }
    if (SharedPrefs.containsKey(SharedPrefs.ongoingProjects)) {
      String? ongoing = SharedPrefs.getString(SharedPrefs.ongoingProjects);
      controller.ongoingProjects.value = jsonDecode(ongoing);
    }
    if (SharedPrefs.containsKey(SharedPrefs.completedProjects)) {
      String? completed = SharedPrefs.getString(SharedPrefs.completedProjects);
      controller.completedProjects.value = jsonDecode(completed);
    }
  }

  @override
  void initState() {
    getProjectItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: DefaultAppBar(
        isLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: Search(text: ''));
              },
              icon: Icon(CupertinoIcons.search,
                  color: Theme.of(context).primaryColorDark)),
          IconButton(
              onPressed: () {
                sortingBottomSheet(
                    context: context,
                    ascendingSort: ascendingSort,
                    descendingSort: descendingSort);
              },
              icon: Icon(
                CupertinoIcons.sort_down,
                color: Theme.of(context).primaryColorDark,
              ))
        ],
        text: 'projects'.tr,
      ),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
                flex: 2,
                child: CustomTabBar(
                  tabList: tabs,
                  displayIndex: controller.displayIndex,
                )),
            if (controller.displayIndex.value == 0)
              Expanded(
                  flex: 12,
                  child: ProjectTabView(
                    tabList: controller.projectItem.value,
                  )),
            if (controller.displayIndex.value == 1)
              Expanded(
                  flex: 12,
                  child: ProjectTabView(
                      tabList: controller.ongoingProjects.value)),
            if (controller.displayIndex.value == 2)
              Expanded(
                  flex: 12,
                  child: ProjectTabView(
                      tabList: controller.completedProjects.value))
          ],
        );
      }));

  void ascendingSort() async {
    controller.projectItem.value
        .sort((a, b) => a["title"].compareTo(b["title"]));
    SharedPrefs.setString(SharedPrefs.projects, jsonEncode(controller.projectItem.value));
  }

  void descendingSort() async {
    controller.projectItem.value
        .sort((a, b) => b["title"].compareTo(a["title"]));
    SharedPrefs.setString(SharedPrefs.projects, jsonEncode(controller.projectItem.value));

  }
}
