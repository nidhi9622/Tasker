import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/projectDetail.dart';
import 'package:task_manager/reusables.dart';
import 'package:task_manager/search.dart';
import 'dashboard.dart';
import 'editTask.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int displayIndex = 0;
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

  late AnimationController controller;
  late Animation<double> animation;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    controller.repeat();
    // animation=CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = CurvedAnimation(curve: Curves.bounceIn, parent: controller);
    getProjectItem();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
          context,
          [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: Search(text: ''));
                },
                icon: Icon(CupertinoIcons.search,
                    color: Theme.of(context).primaryColorDark)),
            IconButton(
                onPressed: () {
                  bottomSheet(deviceSize);
                },
                icon: Icon(
                  CupertinoIcons.sort_down,
                  color: Theme.of(context).primaryColorDark,
                ))
          ],
          'projects'.tr,
          null),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 14, right: 14, top: 17, bottom: 17),
              child: DefaultTabController(
                length: tabs.length,
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
                        tabs: tabs,
                        labelColor: Colors.white,
                        unselectedLabelColor:
                            Colors.red[200] //const Color(0xffffb2a6),
                        ),
                  );
                }),
              ),
            ),
            if (displayIndex == 0) tabView(deviceSize, projectItem),
            if (displayIndex == 1) tabView(deviceSize, ongoingProjects),
            if (displayIndex == 2) tabView(deviceSize, completedProjects)
          ],
        ),
      ),
    );
  }

  void bottomSheet(dynamic deviceSize) {
    showModalBottomSheet(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        backgroundColor: Colors.grey[350],
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              height: deviceSize.height * 0.13,
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      ascendingSort();
                    },
                    child: SizedBox(
                      width: deviceSize.width,
                      height: deviceSize.height * 0.05,
                      child: const Center(
                        child: Text(
                          "Sort : A-Z",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const Divider(thickness: 1),
                  InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        descendingSort();
                      },
                      child: SizedBox(
                        width: deviceSize.width,
                        height: deviceSize.height * 0.05,
                        child: const Center(
                          child: Text('Sort : Z-A',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                      ))
                ],
              ),
            ),
          );
        });
  }

  ascendingSort() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      projectItem.sort((a, b) => a["title"].compareTo(b["title"]));
      preferences.setString('projects', jsonEncode(projectItem));
    });
  }

  descendingSort() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      projectItem.sort((a, b) => b["title"].compareTo(a["title"]));
      preferences.setString('projects', jsonEncode(projectItem));
    });
  }

  void deleteBottomSheet(dynamic deviceSize, dynamic title, int index) {
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
            child: SizedBox(
                height: deviceSize.height * 0.20,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditTask(object: projectItem[index])));
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
                          preferences.remove('$title');
                          projectItem.removeWhere(
                              (element) => element['title'] == title);
                          upcomingProjects.removeWhere(
                              (element) => element['title'] == title);
                          canceledProjects.removeWhere(
                              (element) => element['title'] == title);
                          ongoingProjects.removeWhere(
                              (element) => element['title'] == title);
                          completedProjects.removeWhere(
                              (element) => element['title'] == title);
                          setState(() {
                            preferences.setString(
                                'projects', jsonEncode(projectItem));
                            preferences.setString('canceledProjects',
                                jsonEncode(canceledProjects));
                            preferences.setString('upcomingProjects',
                                jsonEncode(upcomingProjects));
                            preferences.setString('completedProjects',
                                jsonEncode(completedProjects));
                            preferences.setString(
                                'ongoingProjects', jsonEncode(ongoingProjects));
                          });
                          Navigator.of(context).pop();
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

  tabView(dynamic deviceSize, List tabList) {
    return Container(
      height: deviceSize.height * 0.69,
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: tabList.isNotEmpty
          ? ListView.builder(
              itemCount: tabList.length,
              itemBuilder: (context, index) {
                DataModel dataModel = DataModel(tabList[index]);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetail(object: tabList[index])));
                    },
                    onLongPress: () {
                      deleteBottomSheet(deviceSize, dataModel.title, index);
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 18, left: 18, bottom: 18),
                      width: deviceSize.width,
                      height: 128,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor),
                      child: Row(
                        children: [
                          SizedBox(
                            width: deviceSize.width * 0.60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dataModel.title!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                SizedBox(height: deviceSize.height * 0.01),
                                Text(dataModel.subtitle!,
                                    style: const TextStyle(color: Colors.grey)),
                                SizedBox(height: deviceSize.height * 0.02),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: deviceSize.width * 0.02,
                                    ),
                                    Text(
                                      dataModel.date,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: deviceSize.width * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                  radius: 35,
                                  center: Text('${dataModel.percentage!}%'),
                                  animation: true,
                                  animationDuration: 1000,
                                  percent: dataModel.percentage! / 100,
                                  progressColor: Colors.green,
                                  backgroundColor: Colors.grey[300]!,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'noTask'.tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xfffc7474)),
                ),
                SizedBox(height: deviceSize.height * 0.01),
                Text(
                  'noTaskText'.tr,
                  style: TextStyle(color: Colors.red[200], fontSize: 17),
                )
              ],
            ),
    );
  }
}
