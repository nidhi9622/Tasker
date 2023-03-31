import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/default_app_bar.dart';
import 'package:task_manager/app_utils/project_status.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
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
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      controller.projectItem.value = jsonDecode(map);
      controller.ongoingProjects.value.clear();
      controller.completedProjects.value.clear();
      for (int i = 0; i < controller.projectItem.value.length; i++) {
        if (controller.projectItem.value[i]["projectStatus"] ==
            "${ProjectStatus.ongoing}") {
          controller.ongoingProjects.value.add(controller.projectItem.value[i]);
        }
        if (controller.projectItem.value[i]["projectStatus"] ==
            "${ProjectStatus.completed}") {
          controller.completedProjects.value.add(controller.projectItem.value[i]);
        }
      }
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
                showSearch(context: context, delegate: Search(text: '', totalProjectList: controller.projectItem.value));
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
                    tabList: controller.projectItem,
                  )),
            if (controller.displayIndex.value == 1)
              Expanded(
                  flex: 12,
                  child: ProjectTabView(
                      tabList: controller.ongoingProjects)),
            if (controller.displayIndex.value == 2)
              Expanded(
                  flex: 12,
                  child: ProjectTabView(
                      tabList: controller.completedProjects))
          ],
        );
      }));

  void ascendingSort() async {
    List list=
        controller.projectItem.value;
    list.sort((a, b) => a["title"].compareTo(b["title"]));
    controller.projectItem.value=list;
    setState(() {

    });
    //var map = GetPrefs.getString(GetPrefs.projects);
    // controller.projectItem.value
    //     .sort((a, b) => a["title"].compareTo(b["title"]));
    // GetPrefs.setString(
    //     GetPrefs.projects, jsonEncode(controller.projectItem.value));
  }

  void descendingSort() async {
    List list=
        controller.projectItem.value;
    list.sort((a, b) => b["title"].compareTo(a["title"]));
    controller.projectItem.value=list;
    setState(() {

    });
    // controller.projectItem.value
    //     .sort((a, b) => b["title"].compareTo(a["title"]));
    // GetPrefs.setString(
    //     GetPrefs.projects, jsonEncode(controller.projectItem.value));
  }
}
