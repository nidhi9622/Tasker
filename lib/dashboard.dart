import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/editTask.dart';
import 'package:task_manager/processDetail.dart';
import 'package:task_manager/projectDetail.dart';
import 'package:task_manager/reusables.dart';
import 'package:task_manager/search.dart';
import 'package:task_manager/updateUserProfile.dart';
import 'homePage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

String now = DateFormat("MMM dd, yyyy").format(DateTime.now());
List canceledProjects = [];
List upcomingProjects = [];
List completedProjects = [];
List ongoingProjects = [];
List projectItem = [];

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  String username = '';
  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      if (preferences.containsKey('name')) {
        username = preferences.getString('name')!;
      }
    });
  }

  late AnimationController controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String? upcoming;
  String? canceled;
  String? ongoing;
  String? completed;

  Future getProjectItem() async {
    dynamic map;
    SharedPreferences preferences = await SharedPreferences.getInstance();

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
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller.repeat(reverse: true);
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
                    onPressed: () async {
                      bottomSheet(deviceSize);
                    },
                    icon: Icon(
                      CupertinoIcons.sort_down,
                      color: Theme.of(context).primaryColorDark,
                    ))
              ],
              now,
              null),
          body: SafeArea(
            top: true,
            child: SizedBox(
              width: deviceSize.width,
              height: deviceSize.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    username.isNotEmpty
                        ? Container(
                            width: deviceSize.width,
                            height: deviceSize.height * 0.08,
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              '${greetingMessage()} ,  $username',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ))
                        : Container(
                            width: deviceSize.width,
                            height: deviceSize.height * 0.15,
                            padding: const EdgeInsets.all(15),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const UserProfile()));
                              },
                              child: Row(
                                children: [
                                  FadeTransition(
                                      opacity: controller,
                                      child: Text('addProfile'.tr,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))),
                                  // SizedBox(width: deviceSize.width*0.08,),
                                  SizedBox(
                                      width: deviceSize.width * 0.22,
                                      child: Text(
                                        textAlign: TextAlign.end,
                                        'tap'.tr,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ))
                                ],
                              ),
                            ),
                          ),
                    Container(
                      width: deviceSize.width,
                      height: deviceSize.height * 0.27,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Theme.of(context).primaryColor),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              process(
                                  deviceSize,
                                  'Ongoing'.tr,
                                  const Color(0xffae74e3),
                                  const Color(0xffdbb9fa),
                                  Icons.access_time,
                                  ongoingProjects),
                              process(
                                  deviceSize,
                                  'Upcoming'.tr,
                                  const Color(0xfff7b17c),
                                  const Color(0xfffcdec7),
                                  CupertinoIcons.timer_fill,
                                  upcomingProjects),
                            ],
                          ),
                          Row(
                            children: [
                              process(
                                  deviceSize,
                                  'Completed'.tr,
                                  const Color(0xff7cc76d),
                                  const Color(0xffb9faac),
                                  CupertinoIcons.check_mark,
                                  completedProjects),
                              process(
                                  deviceSize,
                                  'Canceled'.tr,
                                  const Color(0xffff7a92),
                                  const Color(0xfffaacba),
                                  CupertinoIcons.clear,
                                  canceledProjects),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 15, right: 15),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectIndex = 2;
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                            },
                            child: SizedBox(
                              width: deviceSize.width * 0.44,
                              child: Row(
                                children: [
                                  Text(
                                    'addProject'.tr,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(width: deviceSize.width * 0.02),
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
                          ),
                          SizedBox(
                            width: deviceSize.width * 0.45,
                            child: Text(
                              'allProject'.tr,
                              textAlign: TextAlign.end,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                        height: deviceSize.height * 0.37,
                        width: deviceSize.width,
                        padding: const EdgeInsets.only(top: 10),
                        child: projectItem.isNotEmpty
                            ? ListView.builder(
                                itemCount: projectItem.length,
                                itemBuilder: (context, index) {
                                  DataModel dataModel =
                                      DataModel(projectItem[index]);
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
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: ListTile(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProjectDetail(
                                                              object:
                                                                  projectItem[
                                                                      index])));
                                            },
                                            leading: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: dataModel
                                                                  .percentage! <
                                                              100
                                                          ? Colors.grey
                                                          : Colors.green),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Icon(
                                                CupertinoIcons.checkmark,
                                                color:
                                                    dataModel.percentage! < 100
                                                        ? Colors.grey
                                                        : Colors.green,
                                              ),
                                            ),
                                            title: Text(dataModel.title!),
                                            subtitle: LinearPercentIndicator(
                                              //leaner progress bar
                                              animation: true,
                                              animationDuration: 1000,
                                              lineHeight: 10.0,
                                              percent:
                                                  dataModel.percentage! / 100,
                                              progressColor:
                                                  dataModel.percentage! < 100
                                                      ? const Color(0xffffb2a6)
                                                      : Colors.green,
                                              barRadius:
                                                  const Radius.circular(10),
                                              backgroundColor: Colors.grey[300],
                                            ),
                                            trailing: sheet(deviceSize,
                                                dataModel.title, index)),
                                      ));
                                },
                              )
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
                                    style: TextStyle(
                                        color: Colors.red[200], fontSize: 17),
                                  )
                                ],
                              ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  process(dynamic deviceSize, String text, Color containerColor,
      Color bubbleColor, IconData icon, List object) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProcessDetail(
                  title: text,
                  object: object,
                )));
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  width: deviceSize.width * 0.444,
                  height: deviceSize.height * 0.10,
                  decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(15)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: bubbleColor,
                radius: 17,
                child: Icon(
                  icon,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sheet(dynamic deviceSize, dynamic title, int index) {
    return PopupMenuButton<int>(
      icon: const Icon(CupertinoIcons.ellipsis_vertical),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditTask(object: projectItem[index])));
            },
            child: Row(
              children: const [
                Icon(CupertinoIcons.pen),
                SizedBox(
                  width: 10,
                ),
                Text("Edit")
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.remove('$title');
            projectItem.removeWhere((element) => element['title'] == title);
            upcomingProjects
                .removeWhere((element) => element['title'] == title);
            canceledProjects
                .removeWhere((element) => element['title'] == title);
            ongoingProjects.removeWhere((element) => element['title'] == title);
            completedProjects
                .removeWhere((element) => element['title'] == title);
            setState(() {
              preferences.setString('projects', jsonEncode(projectItem));
              preferences.setString(
                  'canceledProjects', jsonEncode(canceledProjects));
              preferences.setString(
                  'upcomingProjects', jsonEncode(upcomingProjects));
              preferences.setString(
                  'completedProjects', jsonEncode(completedProjects));
              preferences.setString(
                  'ongoingProjects', jsonEncode(ongoingProjects));
            });
            // Navigator.of(context).pop();
          },
          child: Row(
            children: const [
              Icon(CupertinoIcons.delete),
              SizedBox(
                width: 10,
              ),
              Text("Delete")
            ],
          ),
        ),
      ],
      offset: const Offset(0, 100),
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 2,
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

  String greetingMessage() {
    int timeNow = DateTime.now().hour;
    if (timeNow < 12) {
      return 'Good Morning';
    } else if ((timeNow >= 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  ascendingSort() {
    setState(() {
      projectItem.sort((a, b) => a["title"].compareTo(b["title"]));
    });
  }

  descendingSort() {
    setState(() {
      projectItem.sort((a, b) => b["title"].compareTo(a["title"]));
    });
  }
}
//9602617742
//479