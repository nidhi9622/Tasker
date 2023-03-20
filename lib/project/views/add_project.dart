import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import 'package:task_manager/dashboard/views/homePage.dart';
import '../../dashboard/views/dashboard.dart';
import '../../app_utils/local_notification_service.dart';
import '../../database/app_list.dart';
import '../helper_methods/title_error_dialog.dart';
import '../helper_widgets/add_project_body.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  List ongoingTask = [];
  List completedTasks = [];
  List upcomingTasks = [];
  List canceledTasks = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map map = {};
  bool reminder = true;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  bool preExist = false;

  setData() async {
    if (percentageController.text.isEmpty) {
      setState(() {
        percentageController.text = '0';
      });
    }
    int newPercentage = int.parse(percentageController.text);
    String date = DateFormat("MMM dd, yyyy").format(selectedDate);
    String time = selectedTime.format(context);
    for (int i = 0; i < projectItem.length; i++) {}
    setState(() {
      map = {
        'title': titleController.text,
        'subTitle': subTitleController.text,
        'description': descriptionController.text,
        'percentage': newPercentage,
        'date': date,
        'reminder': reminder,
        'time': time,
        'status': dropdownOptions[dropDown1],
      };
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? mapString;
    List projectList = [];
    List newMap;
    if (preferences.containsKey('projects')) {
      mapString = preferences.getString('projects');
      newMap = jsonDecode(mapString!);
      for (int i = 0; i < newMap.length; i++) {
        if (titleController.text.removeAllWhitespace == newMap[i]['title']) {
          setState(() {
            preExist = true;
          });
        } else {
          setState(() {
            preExist = false;
          });
        }
      }
    }
    if (preExist == true) {
      // ignore: use_build_context_synchronously
      titleErrorDialog(
          context: context,
          content:
              'Project with this title already exist.\nPlease try with another title.',
          isTitle: false);
    } else {
      if (preferences.containsKey('projects')) {
        setState(() {
          mapString = preferences.getString('projects');
          newMap = jsonDecode(mapString!);
          for (int i = 0; i < newMap.length; i++) {
            //print('title is : ${newMap[i]['title']}');
            projectList.add(newMap[i]);
          }
          projectList.add(map);
        });
      } else {
        setState(() {
          projectList.add(map);
        });
      }
      setState(() {
        preferences.setString('projects', jsonEncode(projectList));
      });
      switch (dropDown1) {
        case 0:
          {
            String? mapStringOnGoing;
            List newMapOngoing;
            if (preferences.containsKey('ongoingProjects')) {
              mapStringOnGoing = preferences.getString('ongoingProjects');
              newMapOngoing = jsonDecode(mapStringOnGoing!);
              for (int i = 0; i < newMapOngoing.length; i++) {
                ongoingTask.add(newMapOngoing[i]);
              }
              ongoingTask.add(map);
            } else {
              ongoingTask.add(map);
            }
            String totalProjects = jsonEncode(ongoingTask);
            setState(() {
              preferences.setString('ongoingProjects', totalProjects);
            });
          }
          break;
        case 1:
          {
            String? mapStringCompleted;
            List newMapCompleted;
            if (preferences.containsKey('completedProjects')) {
              mapStringCompleted = preferences.getString('completedProjects');
              newMapCompleted = jsonDecode(mapStringCompleted!);
              for (int i = 0; i < newMapCompleted.length; i++) {
                completedTasks.add(newMapCompleted[i]);
              }
              map['percentage'] = 100;
              completedTasks.add(map);
            } else {
              map['percentage'] = 100;
              completedTasks.add(map);
              projectList[projectList.indexWhere(
                  (element) => element['title'] == titleController.text)] = map;
            }
            setState(() {
              preferences.setString(
                  'completedProjects', jsonEncode(completedTasks));
              preferences.setString('projects', jsonEncode(projectList));
            });
          }
          break;
        case 2:
          {
            String? mapStringUpcoming;
            List newMapUpcoming;
            if (preferences.containsKey('upcomingProjects')) {
              mapStringUpcoming = preferences.getString('upcomingProjects');
              newMapUpcoming = jsonDecode(mapStringUpcoming!);
              for (int i = 0; i < newMapUpcoming.length; i++) {
                upcomingTasks.add(newMapUpcoming[i]);
              }
              upcomingTasks.add(map);
            } else {
              upcomingTasks.add(map);
            }
            String totalProjects = jsonEncode(upcomingTasks);
            setState(() {
              preferences.setString('upcomingProjects', totalProjects);
            });
          }
          break;
        case 3:
          {
            String? mapStringCanceled;
            List newMapCanceled;
            if (preferences.containsKey('canceledProjects')) {
              mapStringCanceled = preferences.getString('canceledProjects');
              newMapCanceled = jsonDecode(mapStringCanceled!);
              for (int i = 0; i < newMapCanceled.length; i++) {
                canceledTasks.add(newMapCanceled[i]);
              }
              canceledTasks.add(map);
            } else {
              canceledTasks.add(map);
            }
            String totalProjects = jsonEncode(canceledTasks);
            setState(() {
              preferences.setString('canceledProjects', totalProjects);
            });
          }
          break;
      }
      if (reminder) {
        int? id = preferences.getInt('id');
        LocalNotificationService.showScheduleNotification(
            id: id!,
            title: 'Reminder',
            body: 'Start your ${titleController.text} task now',
            payload: jsonEncode(map),
            scheduleTime: DateTime(selectedDate.year, selectedDate.month,
                selectedDate.day, selectedTime.hour, selectedTime.minute));
        setState(() {
          preferences.setInt('id', id + 1);
        });
      }
      LocalNotificationService.initialize(context: context, object: map);
      // ignore: use_build_context_synchronously
      await titleErrorDialog(
          context: context, content: 'success'.tr, isTitle: true);
      setState(() {
        selectIndex = 0;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  dispose() {
    super.dispose();
    titleController.dispose();
    subTitleController.dispose();
    descriptionController.dispose();
    percentageController.dispose();
  }

  int dropDown1 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        text: 'newProject'.tr,
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            if (titleController.text.isEmpty ||
                subTitleController.text.isEmpty) {
              await titleErrorDialog(
                  context: context, content: 'error'.tr, isTitle: true);
            } else {
              await setData();
            }
          }
        },
        isLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: AddProjectBody(
            titleController: titleController,
            subTitleController: subTitleController,
            descriptionController: descriptionController,
            percentageController: percentageController,
            reminder: reminder,
            dropdownValue: dropDown1,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
          ),
        ),
      ),
    );
  }
}
