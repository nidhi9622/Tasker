import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/default_app_bar.dart';
import 'package:task_manager/dashboard/helper_methods/search.dart';
import 'package:task_manager/project/helper_methods/sorting_bottom_sheet.dart';
import 'package:task_manager/project/helper_widgets/custom_tab_bar.dart';
import '../../database/app_list.dart';
import '../helper_widgets/project_tab_view.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}
class _ProjectsState extends State<Projects>{
  ValueNotifier<int> displayIndex=ValueNotifier(0);
  List completedProjects = [];
  List ongoingProjects = [];
  List projectItem = [];
  String? ongoing;
  String? completed;

  getProjectItem() async {
    dynamic map;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('projects')) {
      map = preferences.getString('projects');
      setState(() {
        projectItem = jsonDecode(map);
      });
    }
    if (preferences.containsKey('ongoingProjects')) {
      ongoing = preferences.getString('ongoingProjects');
      setState(() {
        ongoingProjects = jsonDecode(ongoing!);
      });
    }
    if (preferences.containsKey('completedProjects')) {
      completed = preferences.getString('completedProjects');
      setState(() {
        completedProjects = jsonDecode(completed!);
      });
    }
  }

  @override
  void initState() {
    getProjectItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar:DefaultAppBar(isLeading: false, actions: [
        IconButton(
            onPressed: () {
              showSearch(context: context, delegate: Search(text: ''));
            },
            icon: Icon(CupertinoIcons.search,
                color: Theme.of(context).primaryColorDark)),
        IconButton(
            onPressed: () {
              sortingBottomSheet(context: context, ascendingSort: ascendingSort, descendingSort: descendingSort);
            },
            icon: Icon(
              CupertinoIcons.sort_down,
              color: Theme.of(context).primaryColorDark,
            ))
      ], text: 'projects'.tr,) ,
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          builder: (context,value,child) {
            return Column(
              children: [
                CustomTabBar(tabList: tabs, displayIndex: displayIndex,),
                if (displayIndex.value == 0) ProjectTabView(tabList: projectItem,),
                if (displayIndex.value == 1) ProjectTabView(tabList:ongoingProjects),
                if (displayIndex.value == 2) ProjectTabView(tabList: completedProjects)
              ],
            );
          }, valueListenable: displayIndex,
        ),
      ),
    );

  void ascendingSort() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      projectItem.sort((a, b) => a["title"].compareTo(b["title"]));
      preferences.setString('projects', jsonEncode(projectItem));
    });
  }

  void descendingSort() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      projectItem.sort((a, b) => b["title"].compareTo(a["title"]));
      preferences.setString('projects', jsonEncode(projectItem));
    });
  }
}
