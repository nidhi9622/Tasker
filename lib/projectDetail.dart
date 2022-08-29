import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/dashboard.dart';
import 'package:task_manager/editTask.dart';
import 'package:task_manager/homePage.dart';
import 'package:task_manager/reusables.dart';
import 'package:task_manager/search.dart';
import 'addSubTask.dart';
import 'editSubTask.dart';

class ProjectDetail extends StatefulWidget {
  Map object;
  ProjectDetail({Key? key, required this.object}) : super(key: key);
  @override
  State<ProjectDetail> createState() => _ProjectDetailState(object: object);
}

class _ProjectDetailState extends State<ProjectDetail> {
  Map object;
  List subTaskList = [];
  late DataModel dataModel;
  String? notes = '';
  TextEditingController shortcutController = TextEditingController();
  bool newField = false;
  double containerWidth = 0.67;
  int maxLength = 20;
  int displayIndex = 0;
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
    if (preferences.containsKey('${object['title']} notes')) {
      setState(() {
        notes = preferences.getString('${object['title']} notes');
      });
      notesController = TextEditingController(text: notes);
    }
    if (preferences.containsKey('${object['title']} searchShortcut')) {
      searchString = preferences.getString('${object['title']} searchShortcut');
      setState(() {
        searchShortcut = jsonDecode(searchString!);
      });
    }
    if (preferences.containsKey('${object['title']}')) {
      subTask = preferences.getString('${object['title']}');
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

    if (preferences.containsKey('${object['title']}')) {
      String? subtask = preferences.getString('${object['title']}');
      setState(() {
        subTaskList = jsonDecode(subtask!);
      });
      for (int i = 0; i < subTaskList.length; i++) {
        totalPercentage += subTaskList[i]['percentage'];
      }
      // print('percentage is ${object['percentage']}');
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
        totalPercentage = object['percentage'];
      });
    }
  }

  late TextEditingController notesController;

  @override
  initState() {
    dataModel = DataModel(object);
    notesController = TextEditingController(text: notes);

    getData();
    super.initState();
  }

  _ProjectDetailState({required this.object});
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: Search(text: ''));
                  },
                  icon: Icon(
                    CupertinoIcons.search,
                    color: Theme.of(context).primaryColorDark,
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
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
                        padding:
                            const EdgeInsets.only(top: 8, left: 10, right: 10),
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
                                                    object: object,
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
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(width: deviceSize.width * 0.02),
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
                                                    width:
                                                        deviceSize.width * 0.20,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green[50],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Center(
                                                        child: Text(
                                                      searchShortcut[index],
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    BorderRadius.circular(20)),
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
                                                controller: shortcutController,
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
                                          await SharedPreferences.getInstance();
                                      searchShortcut
                                          .add(shortcutController.text);
                                      preferences.setString(
                                          '${object['title']} searchShortcut',
                                          jsonEncode(searchShortcut));
                                    }
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProjectDetail(object: object)));
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 17, bottom: 17),
                  child: DefaultTabController(
                    length: detailedPageTab.length,
                    child: Builder(builder: (context) {
                      final TabController tabController =
                          DefaultTabController.of(context)!;
                      tabController.addListener(() {
                        setState(() {
                          displayIndex = tabController.index;
                        });
                      });
                      return Container(
                        height: 65,
                        width: deviceSize.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: TabBar(
                          padding: const EdgeInsets.all(8),
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.red[200]),
                          tabs: detailedPageTab,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.red[200],
                        ),
                      );
                    }),
                  ),
                ),
                if (displayIndex == 0)
                  SizedBox(
                      height: deviceSize.height * 0.39,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AddSubTask(object: object)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 4, right: 15),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: deviceSize.width * 0.45,
                                    child: Row(
                                      children: [
                                        Text(
                                          'addTask'.tr,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                            width: deviceSize.width * 0.02),
                                        CircleAvatar(
                                            backgroundColor: Colors.red[200],
                                            radius: 13,
                                            child: const Icon(
                                              CupertinoIcons.add,
                                              color: Colors.white,
                                            ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                              height: deviceSize.height * 0.336,
                              padding: const EdgeInsets.only(top: 10),
                              child: subTaskList.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: subTaskList.length,
                                      itemBuilder: (context, index) {
                                        DataModel dataModel =
                                            DataModel(subTaskList[index]);
                                        return Container(
                                            width: deviceSize.width,
                                            padding: const EdgeInsets.only(
                                                left: 22,
                                                right: 22,
                                                bottom: 12,
                                                top: 6),
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                              child: ListTile(
                                                onTap: () async {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditSubTask(
                                                                object:
                                                                    subTaskProjects[
                                                                        index],
                                                                title: object[
                                                                    'title'],
                                                                homeObject:
                                                                    object,
                                                              )));
                                                  // await _showDialogBox(context,subTaskList[index]);
                                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProjectDetail(object:subTaskList[index])));
                                                },
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                      CupertinoIcons
                                                          .ellipsis_vertical),
                                                  onPressed: () {
                                                    deleteBottomSheet(
                                                        deviceSize,
                                                        dataModel.title,
                                                        index,
                                                        object);
                                                  },
                                                ),
                                                leading: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: dataModel
                                                                      .percentage! <
                                                                  100
                                                              ? Colors.grey
                                                              : Colors.green),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                  child: Icon(
                                                    CupertinoIcons.checkmark,
                                                    color:
                                                        dataModel.percentage! <
                                                                100
                                                            ? Colors.grey
                                                            : Colors.green,
                                                  ),
                                                ),
                                                title: Text(dataModel.title!),
                                                subtitle:
                                                    LinearPercentIndicator(
                                                  //leaner progress bar
                                                  animation: true,
                                                  animationDuration: 1000,
                                                  lineHeight: 10.0,
                                                  percent:
                                                      dataModel.percentage! /
                                                          100,
                                                  progressColor:
                                                      dataModel.percentage! <
                                                              100
                                                          ? Colors.red[200]
                                                          : Colors.green,
                                                  barRadius:
                                                      const Radius.circular(10),
                                                  backgroundColor:
                                                      Colors.grey[300],
                                                ),
                                              ),
                                            ));
                                      },
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('noTask'.tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                                color: Color(0xfffc7474))),
                                        SizedBox(
                                            height: deviceSize.height * 0.01),
                                        Text(
                                          'noTaskText'.tr,
                                          style: const TextStyle(
                                              color: Color(0xfffc97a1),
                                              fontSize: 17),
                                        )
                                      ],
                                    ))
                        ],
                      )),
                if (displayIndex == 1)
                  Container(
                    width: deviceSize.width,
                    color: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(12),
                    constraints:
                        BoxConstraints(maxHeight: deviceSize.height * 0.378),
                    child: TextField(
                      controller: notesController,
                      style: const TextStyle(fontSize: 20),
                      onChanged: (value) async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        setState(() {
                          preferences.setString(
                              '${object['title']} notes', notesController.text);
                        });
                      },
                      maxLength: null,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'addNotes'.tr,
                          hintStyle: const TextStyle(fontSize: 25)),
                    ),
                  )
              ],
            ),
          )),
    );
  }

/*  _showDialogBox(BuildContext context,dynamic list){
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('updatePercentage'.tr),
          content: TextField(
            keyboardType:TextInputType.number,
            controller:percentageController,decoration: InputDecoration(hintText: 'percentage'.tr),),
          actions: [
            TextButton(
              child: Center(child: Text('ok'.tr)),
              onPressed: () async{
                SharedPreferences preferences=await SharedPreferences.getInstance();
                if(percentageController.text.isEmpty){
                  setState(() {
                    percentageController.text='0';
                  });
                }
                int newPercentage =int.parse(percentageController.text);
                Map map=list;
                map['percentage']=newPercentage;
                subTaskList[subTaskList.indexWhere((element) => element['title'] == list['title'])] = map;
               /* subTaskList.removeWhere((element) => element['title'] == list['title']);
                subTaskList.add(map);*/
                setState(() {
                  preferences.setString('${object['title']}', jsonEncode(subTaskList));
                });
                 // Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProjectDetail(object: object)));
              },
            ),
          ],
        );
      },
    );
  }*/
  void deleteBottomSheet(
      dynamic deviceSize, dynamic title, int index, Map homeObject) {
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
            child: SizedBox(
                height: deviceSize.height * 0.20,
                width: 100,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditSubTask(
                                  object: subTaskProjects[index],
                                  title: object['title'],
                                  homeObject: homeObject,
                                )));
                      },
                      child: ListTile(
                        title: const Text('Edit'),
                        trailing: const Icon(CupertinoIcons.pen),
                        tileColor: Colors.grey[350],
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    InkWell(
                        onTap: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          setState(() {
                            subTaskProjects.removeWhere(
                                (element) => element['title'] == title);
                            preferences.setString('${object['title']}',
                                jsonEncode(subTaskProjects));
                          });
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProjectDetail(object: object)));
                        },
                        child: ListTile(
                          title: const Text('Delete'),
                          trailing: const Icon(CupertinoIcons.delete),
                          tileColor: Colors.grey[350],
                        )),
                  ],
                )),
          );
        });
  }
}
/*void main() {
  List noList = [
    {'title':'hello','subTitle':'sub'},
    {"id": 2, "name": "Alex"},
  ];
  List list=[1,2,3,4];
  noList[noList.indexWhere((element) => element['title'] == 'hello')] = {'title':'bye','subTitle':'sub'};
  print(noList);
  Map map={'title':'123','subTitle':'456'};
  noList.removeWhere((element) => element['title'] == 'hello');
  noList.add(map);
//  print(noList);
}*/
