import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_container.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_left.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_right.dart';
import '../../../app_utils/global_data.dart';
import '../../../database/app_list.dart';
import '../../../models/data_model.dart';
import 'custom_tab_bar.dart';

class ProjectDetailBody extends StatefulWidget {
  final Map object;

  const ProjectDetailBody({Key? key, required this.object}) : super(key: key);

  @override
  State<ProjectDetailBody> createState() => _ProjectDetailBodyState();
}

class _ProjectDetailBodyState extends State<ProjectDetailBody> {
  List subTaskList = [];
  late DataModel dataModel;
  String? notes = '';
  ValueNotifier<int> displayIndex = ValueNotifier(0);
  dynamic totalPercentage = 0;
  List optionList = [];
  Map map = {};
  List subTaskProjects = [];

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('${widget.object['title']} notes')) {
      setState(() {
        notes = preferences.getString('${widget.object['title']} notes');
      });
      notesController = TextEditingController(text: notes);
    }
    if (preferences.containsKey('${widget.object['title']}')) {
      String? subTask = preferences.getString('${widget.object['title']}');
      setState(() {
        subTaskProjects = jsonDecode(subTask!);
      });
    }
    if (preferences.containsKey('ongoingProjects')) {
      String? ongoing = preferences.getString('ongoingProjects');
      setState(() {
        ongoingProjects = jsonDecode(ongoing!);
      });
    }
    if (preferences.containsKey('upcomingProjects')) {
      String? upcoming = preferences.getString('upcomingProjects');
      setState(() {
        upcomingProjects = jsonDecode(upcoming!);
      });
    }
    if (preferences.containsKey('canceledProjects')) {
      String? cancel = preferences.getString('canceledProjects');
      setState(() {
        canceledProjects = jsonDecode(cancel!);
      });
    }
    if (preferences.containsKey('completedProjects')) {
      String? completed = preferences.getString('completedProjects');
      setState(() {
        completedProjects = jsonDecode(completed!);
      });
    }

    if (preferences.containsKey('${widget.object['title']}')) {
      String? subtask = preferences.getString('${widget.object['title']}');
      setState(() {
        subTaskList = jsonDecode(subtask!);
      });
      for (int i = 0; i < subTaskList.length; i++) {
        totalPercentage += subTaskList[i]['percentage'];
      }
      // print('percentage is ${widget.object['percentage']}');
      setState(() {
        totalPercentage = (totalPercentage / subTaskList.length).round();
      });
      String? projectName = preferences.getString('projects');
      optionList = jsonDecode(projectName!);
      setState(() {
        map = {
          'title': dataModel.title,
          'subTitle': dataModel.subtitle,
          'description': dataModel.description,
          'percentage': totalPercentage,
          'date': dataModel.date,
          'reminder': dataModel.reminder,
          'time': dataModel.time,
          'status': dataModel.status,
        };
      });

      optionList[optionList
          .indexWhere((element) => element['title'] == dataModel.title)] = map;
      setState(() {
        preferences.setString('projects', jsonEncode(optionList));
      });
      if (dataModel.status == 'Ongoing') {
        // ongoingProjects.removeWhere((element) => element['title'] ==dataModel.title);
        // ongoingProjects.add(map);
        ongoingProjects[ongoingProjects.indexWhere(
            (element) => element['title'] == dataModel.title)] = map;
        setState(() {
          preferences.setString('ongoingProjects', jsonEncode(ongoingProjects));
        });
      }
      if (map['status'] == 'Upcoming') {
        upcomingProjects[upcomingProjects.indexWhere(
            (element) => element['title'] == dataModel.title)] = map;
        setState(() {
          preferences.setString(
              'upcomingProjects', jsonEncode(upcomingProjects));
        });
      }
      if (map['status'] == 'Canceled') {
        canceledProjects[canceledProjects.indexWhere(
            (element) => element['title'] == dataModel.title)] = map;
        setState(() {
          preferences.setString(
              'canceledProjects', jsonEncode(canceledProjects));
        });
      }
      if (map['status'] == 'Complete') {
        completedProjects[completedProjects.indexWhere(
            (element) => element['title'] == dataModel.title)] = map;
        setState(() {
          preferences.setString(
              'completedProjects', jsonEncode(completedProjects));
        });
      }
    } else {
      setState(() {
        totalPercentage = widget.object['percentage'];
      });
    }
  }

  late TextEditingController notesController;

  @override
  initState() {
    dataModel = DataModel(widget.object);
    notesController = TextEditingController(text: notes);
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      child: ValueListenableBuilder(
          valueListenable: displayIndex,
          builder: (context, _, child) {
            return Column(
              children: [
                ProjectDetailContainer(
                  object: widget.object,
                  totalPercentage: totalPercentage,
                  dataModel: dataModel,
                ),
                CustomTabBar(
                  tabList: detailedPageTab,
                  displayIndex: displayIndex,
                ),
                if (displayIndex.value == 0)
                  ProjectDetailLeft(
                      object: widget.object,
                      subTaskList: subTaskList,
                      subTaskProjects: subTaskProjects),
                if (displayIndex.value == 1)
                  ProjectDetailRight(
                    object: widget.object,
                    notesController: notesController,
                  )
              ],
            );
          }));
}
