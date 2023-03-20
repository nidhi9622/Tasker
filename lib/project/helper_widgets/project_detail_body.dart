import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/project/helper_widgets/project_detail_left.dart';
import 'package:task_manager/project/helper_widgets/project_detail_right.dart';
import '../../dashboard/helper_methods/search.dart';
import '../../dashboard/views/dashboard.dart';
import '../../database/app_list.dart';
import '../../models/data_model.dart';
import '../views/edit_task.dart';
import '../views/project_detail.dart';
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
  TextEditingController shortcutController = TextEditingController();
  bool newField = false;
  double containerWidth = 0.67;
  int maxLength = 20;
  ValueNotifier<int> displayIndex = ValueNotifier(0);
  int dropDown1 = -1;
  dynamic totalPercentage = 0;
  List optionList = [];
  TextEditingController percentageController =
      TextEditingController(text: '100');
  String? ongoing;
  String? completed;
  Map map = {};
  String? subTask;
  String? cancel;
  String? upcoming;
  List subTaskProjects = [];
  List searchShortcut = [];
  String? searchString;

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('${widget.object['title']} notes')) {
      setState(() {
        notes = preferences.getString('${widget.object['title']} notes');
      });
      notesController = TextEditingController(text: notes);
    }
    if (preferences.containsKey('${widget.object['title']} searchShortcut')) {
      searchString =
          preferences.getString('${widget.object['title']} searchShortcut');
      setState(() {
        searchShortcut = jsonDecode(searchString!);
      });
    }
    if (preferences.containsKey('${widget.object['title']}')) {
      subTask = preferences.getString('${widget.object['title']}');
      setState(() {
        subTaskProjects = jsonDecode(subTask!);
      });
    }
    if (preferences.containsKey('ongoingProjects')) {
      ongoing = preferences.getString('ongoingProjects');
      setState(() {
        ongoingProjects = jsonDecode(ongoing!);
      });
    }
    if (preferences.containsKey('upcomingProjects')) {
      upcoming = preferences.getString('upcomingProjects');
      setState(() {
        upcomingProjects = jsonDecode(upcoming!);
      });
    }
    if (preferences.containsKey('canceledProjects')) {
      cancel = preferences.getString('canceledProjects');
      setState(() {
        canceledProjects = jsonDecode(cancel!);
      });
    }
    if (preferences.containsKey('completedProjects')) {
      completed = preferences.getString('completedProjects');
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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: ValueListenableBuilder(
            valueListenable: displayIndex,
            builder: (context, _, child) {
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        color: Theme.of(context).primaryColor,
                      ),
                      Container(
                          width: deviceSize.width,
                          height: deviceSize.height * 0.40,
                          padding: const EdgeInsets.only(
                              top: 8, left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context).primaryColor),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '${dataModel.title}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceSize.width * 0.02,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => EditTask(
                                                      object: widget.object,
                                                    )));
                                      },
                                      icon: const Icon(CupertinoIcons.pen))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${dataModel.subtitle}',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                              SizedBox(height: deviceSize.height * 0.02),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: CircularPercentIndicator(
                                      radius: 44,
                                      center: Text(
                                        '$totalPercentage %',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                      animation: true,
                                      animationDuration: 1000,
                                      percent: totalPercentage < 101
                                          ? totalPercentage / 100
                                          : 100 / 100,
                                      progressColor: Colors.green,
                                      backgroundColor: Colors.grey[300]!,
                                    ),
                                  ),
                                  SizedBox(
                                    width: deviceSize.width * 0.60,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'status'.tr,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        SizedBox(
                                            width: deviceSize.width * 0.02),
                                        Text(dataModel.status!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              // SizedBox(height: deviceSize.height*0.02),
                              Row(
                                children: [
                                  SizedBox(
                                      width: deviceSize.width * containerWidth,
                                      height: deviceSize.height * 0.05,
                                      child: searchShortcut.isNotEmpty
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: searchShortcut.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    showSearch(
                                                        context: context,
                                                        delegate: Search(
                                                            text:
                                                                '${searchShortcut[index]}'));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Container(
                                                      width: deviceSize.width *
                                                          0.20,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Colors.green[50],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Center(
                                                          child: Text(
                                                        searchShortcut[index],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.green),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                    ),
                                                  ),
                                                );
                                              })
                                          : Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                'shortSearch'.tr,
                                                textAlign: TextAlign.end,
                                              ),
                                            )),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          newField = true;
                                          containerWidth = 0.58;
                                        });
                                      },
                                      child: newField
                                          ? Container(
                                              width: 70,
                                              constraints: const BoxConstraints(
                                                  maxHeight: 50),
                                              decoration: BoxDecoration(
                                                  color: Colors.green[50],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5,
                                                  right: 3,
                                                ),
                                                child: TextField(
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  inputFormatters: [
                                                    LengthLimitingTextInputFormatter(
                                                        maxLength),
                                                  ],
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              InputBorder.none),
                                                  controller:
                                                      shortcutController,
                                                ),
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 17,
                                              backgroundColor: Colors.green,
                                              child: Icon(
                                                CupertinoIcons.add,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            )),
                                  SizedBox(width: deviceSize.width * 0.02),
                                  InkWell(
                                    onTap: () async {
                                      if (shortcutController.text.isNotEmpty) {
                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        searchShortcut
                                            .add(shortcutController.text);
                                        preferences.setString(
                                            '${widget.object['title']} searchShortcut',
                                            jsonEncode(searchShortcut));
                                      }
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProjectDetail(
                                                      object: widget.object)));
                                    },
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 80),
                                      decoration: BoxDecoration(
                                          color: Colors.green[50],
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          'done'.tr,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ))
                    ],
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
}
