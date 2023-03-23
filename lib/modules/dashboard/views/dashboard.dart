import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/default_app_bar.dart';
import 'package:task_manager/modules/dashboard/controller/dashboard_controller.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/shared_prefs/shared_prefs.dart';
import '../../../ui_utils/no_task_widget.dart';
import '../../project/helper_methods/sorting_bottom_sheet.dart';
import '../helper_methods/search.dart';
import '../helper_widgets/add_project_widget.dart';
import '../helper_widgets/name_animate_widget.dart';
import '../helper_widgets/process_widget_container.dart';
import '../helper_widgets/project_item_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>{
  DashboardController controller = Get.put(DashboardController());

  getData() async {
      if (SharedPrefs.containsKey(SharedPrefs.userName)) {
        controller.username.value = SharedPrefs.getString(SharedPrefs.userName);
      }
  }

  Future getProjectItem() async {

    if (SharedPrefs.containsKey(SharedPrefs.projects)) {
        var map = SharedPrefs.getString(SharedPrefs.projects);
        projectItem = jsonDecode(map);
    }
    if (SharedPrefs.containsKey(SharedPrefs.upcomingProjects)) {
        var upcoming = SharedPrefs.getString(SharedPrefs.upcomingProjects);
        upcomingProjects = jsonDecode(upcoming);
    }
    if (SharedPrefs.containsKey(SharedPrefs.canceledProjects)) {
        var canceled = SharedPrefs.getString(SharedPrefs.canceledProjects);
        canceledProjects = jsonDecode(canceled);
    }
    if (SharedPrefs.containsKey(SharedPrefs.ongoingProjects)) {
        var ongoing = SharedPrefs.getString(SharedPrefs.ongoingProjects);
        ongoingProjects = jsonDecode(ongoing);
    }
    if (SharedPrefs.containsKey(SharedPrefs.completedProjects)) {
        var completed = SharedPrefs.getString(SharedPrefs.completedProjects);
        completedProjects = jsonDecode(completed);
    }
  }

  @override
  void initState() {
    getProjectItem();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
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
                  onPressed: () async {
                    await sortingBottomSheet(
                        context: context,
                        ascendingSort: ascendingSort,
                        descendingSort: descendingSort);
                  },
                  icon: Icon(
                    CupertinoIcons.sort_down,
                    color: Theme.of(context).primaryColorDark,
                  ))
            ],
            text: currentDate,
          ),
          body: SizedBox(
            width: double.infinity,
            height:  double.infinity,
            child: SingleChildScrollView(
              child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NameAnimateWidget(username: controller.username.value),
                      const ProcessWidgetContainer(),
                      const AddProjectWidget(),
                      Container(
                          width:  double.infinity,
                          padding: const EdgeInsets.only(top: 10),
                          child: projectItem.isNotEmpty
                              ? const ProjectItemList()
                              : const NoTaskWidget())
                    ],
                  );
                }
              ),
            ),
          ),
        ));
  }

  ascendingSort() async {
    setState(() {
      projectItem.sort((a, b) => a["title"].compareTo(b["title"]));
      SharedPrefs.setString(SharedPrefs.projects, jsonEncode(projectItem));
    });
  }

  descendingSort() async {
    setState(() {
      projectItem.sort((a, b) => b["title"].compareTo(a["title"]));
      SharedPrefs.setString(SharedPrefs.projects, jsonEncode(projectItem));
    });
  }
}
