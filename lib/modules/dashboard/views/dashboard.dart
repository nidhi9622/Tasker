import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/default_app_bar.dart';
import 'package:task_manager/modules/dashboard/controller/dashboard_controller.dart';
import '../../../app_utils/global_data.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
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

class _DashboardState extends State<Dashboard> {
  DashboardController controller = Get.put(DashboardController());

  getData() async {
    if (GetPrefs.containsKey(GetPrefs.userName)) {
      controller.username.value = GetPrefs.getString(GetPrefs.userName);
    }
  }

  @override
  void initState() {
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      controller.projectList.value = jsonDecode(map);
    }
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: DefaultAppBar(
          isLeading: false,
          actions: [
            IconButton(
                onPressed: () => showSearch(
                    context: context,
                    delegate: Search(
                        text: '',
                        totalProjectList: controller.projectList.value)),
                icon: Icon(CupertinoIcons.search,
                    color: Theme.of(context).primaryColorDark)),
            IconButton(
                onPressed: () async => await sortingBottomSheet(
                    context: context,
                    ascendingSort: ascendingSort,
                    descendingSort: descendingSort),
                icon: Icon(
                  CupertinoIcons.sort_down,
                  color: Theme.of(context).primaryColorDark,
                ))
          ],
          text: currentDate,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NameAnimateWidget(username: controller.username.value),
                const ProcessWidgetContainer(),
                const AddProjectWidget(),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 10),
                    child: controller.projectList.value == [] ||
                            controller.projectList.value.isEmpty
                        ? const NoTaskWidget()
                        : ProjectItemList(
                            controller: controller,
                          ))
              ],
            ),
          ),
        ),
      ));

  ascendingSort() async {
    setState(() {
      List list = controller.projectList.value;

      list.sort((a, b) =>
          a["title"].toLowerCase().compareTo(b["title"].toLowerCase()));
      controller.projectList.value = list;
      // GetPrefs.setString(
      //     GetPrefs.projects, jsonEncode(controller.projectList.value));
    });
  }

  descendingSort() async {
    setState(() {
      List list = controller.projectList.value;
      list.sort((a, b) =>
          b["title"].toLowerCase().compareTo(a["title"].toLowerCase()));
      controller.projectList.value = list;
      // GetPrefs.setString(
      //     GetPrefs.projects, jsonEncode(controller.projectList.value));
    });
  }
}
