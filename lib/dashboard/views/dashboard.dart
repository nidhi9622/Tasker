import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/default_app_bar.dart';
import 'package:task_manager/dashboard/helper_methods/search.dart';
import 'package:task_manager/dashboard/helper_widgets/name_animate_widget.dart';
import 'package:task_manager/dashboard/helper_widgets/process_widget_container.dart';
import 'package:task_manager/project/helper_methods/sorting_bottom_sheet.dart';
import 'package:task_manager/ui_utils/no_task_widget.dart';
import '../../app_utils/global_data.dart';
import '../helper_widgets/add_project_widget.dart';
import '../helper_widgets/project_item_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String username = '';

  getData() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.containsKey('name')) {
        username = preferences.getString('name')!;
      }
    });
  }

  String? upcoming;
  String? canceled;
  String? ongoing;
  String? completed;
  late SharedPreferences preferences;
  Future getProjectItem() async {
    dynamic map;
    preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey('projects')) {
      setState(() {
        map = preferences.getString('projects');
        projectItem = jsonDecode(map);
      });
    }
    if (preferences.containsKey('upcomingProjects')) {
      setState(() {
        upcoming = preferences.getString('upcomingProjects');
        upcomingProjects = jsonDecode(upcoming!);
      });
    }
    if (preferences.containsKey('canceledProjects')) {
      setState(() {
        canceled = preferences.getString('canceledProjects');
        canceledProjects = jsonDecode(canceled!);
      });
    }
    if (preferences.containsKey('ongoingProjects')) {
      setState(() {
        ongoing = preferences.getString('ongoingProjects');
        ongoingProjects = jsonDecode(ongoing!);
      });
    }
    if (preferences.containsKey('completedProjects')) {
      setState(() {
        completed = preferences.getString('completedProjects');
        completedProjects = jsonDecode(completed!);
      });
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
    final deviceSize = MediaQuery.of(context).size;
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
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NameAnimateWidget(username: username),
                  const ProcessWidgetContainer(),
                  const AddProjectWidget(),
                  Container(
                      height: deviceSize.height * 0.37,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10),
                      child: projectItem.isNotEmpty
                          ? const ProjectItemList()
                          : const NoTaskWidget())
                ],
              ),
            ),
          ),
        ));
  }

  ascendingSort() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      projectItem.sort((a, b) => a["title"].compareTo(b["title"]));
      preferences.setString('projects', jsonEncode(projectItem));
    });
  }

  descendingSort() async {
   // SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      projectItem.sort((a, b) => b["title"].compareTo(a["title"]));
      preferences.setString('projects', jsonEncode(projectItem));
    });
  }
}
