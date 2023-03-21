import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_utils/app_routes.dart';
import '../../app_utils/global_data.dart';
import '../../database/app_list.dart';
import '../../models/data_model.dart';
import '../helper_methods/title_error_dialog.dart';
import '../../app_utils/local_notification_service.dart';
import '../helper_widgets/edit_task_body.dart';

class EditTask extends StatefulWidget {
  final Map object;

  const EditTask({Key? key, required this.object}) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

int newId = 0;

class _EditTaskState extends State<EditTask> {
  late TextEditingController titleController;
  late TextEditingController subTitleController;
  late TextEditingController percentageController;
  int dropDown1 = 0;
  late TextEditingController descriptionController;
  bool? reminder;
  List optionList = [];
  dynamic status;
  Map map = {};
  ValueNotifier selectedDate = ValueNotifier(dynamic);
  ValueNotifier selectedTime = ValueNotifier(dynamic);
  ValueNotifier<DateTime> stringDate = ValueNotifier(DateTime.now());
  ValueNotifier<TimeOfDay> stringTime = ValueNotifier(TimeOfDay.now());
  late DataModel dataModel;

  setTaskData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? projectName = preferences.getString('projects');
    optionList = jsonDecode(projectName!);

    String? upcoming;
    String? canceled;
    String? ongoing;
    String? completed;
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

    if (percentageController.text.isEmpty) {
      setState(() {
        percentageController.text = '0';
      });
    }
    int newPercentage = int.parse(percentageController.text);
    setState(() {
      map = {
        'title': titleController.text,
        'subTitle': subTitleController.text,
        'description': descriptionController.text,
        'percentage': newPercentage,
        'date': selectedDate.value,
        'reminder': reminder,
        'time': selectedTime.value,
        'status': dropdownOptions[dropDown1],
      };
    });
    optionList[optionList
        .indexWhere((element) => element['title'] == dataModel.title)] = map;
    setState(() {
      preferences.setString('projects', jsonEncode(optionList));
    });

    switch (dropDown1) {
      case 0:
        {
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects.add(map);
          setState(() {
            preferences.setString(
                'canceledProjects', jsonEncode(canceledProjects));
            preferences.setString(
                'upcomingProjects', jsonEncode(upcomingProjects));
            preferences.setString(
                'completedProjects', jsonEncode(completedProjects));
            preferences.setString(
                'ongoingProjects', jsonEncode(ongoingProjects));
          });
        }
        break;
      case 1:
        {
          List list = [];
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          if (preferences.containsKey('${widget.object['title']}')) {
            String? string = preferences.getString('${widget.object['title']}');
            list = jsonDecode(string!);
            for (int i = 0; i < list.length; i++) {
              list[i]['percentage'] = 100;
            }
          } else {
            map['percentage'] = 100;
            optionList[optionList.indexWhere(
                (element) => element['title'] == dataModel.title)] = map;
          }
          completedProjects.add(map);
          setState(() {
            preferences.setString(
                'canceledProjects', jsonEncode(canceledProjects));
            preferences.setString(
                'upcomingProjects', jsonEncode(upcomingProjects));
            preferences.setString(
                'completedProjects', jsonEncode(completedProjects));
            preferences.setString(
                'ongoingProjects', jsonEncode(ongoingProjects));
            preferences.setString(
                '${widget.object['title']}', jsonEncode(list));
            preferences.setString('projects', jsonEncode(optionList));
          });
        }
        break;
      case 2:
        {
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          upcomingProjects.add(map);
          setState(() {
            preferences.setString(
                'canceledProjects', jsonEncode(canceledProjects));
            preferences.setString(
                'upcomingProjects', jsonEncode(upcomingProjects));
            preferences.setString(
                'completedProjects', jsonEncode(completedProjects));
            preferences.setString(
                'ongoingProjects', jsonEncode(ongoingProjects));
          });
        }
        break;
      case 3:
        {
          upcomingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          ongoingProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          completedProjects
              .removeWhere((element) => element['title'] == dataModel.title);
          canceledProjects.add(map);
          setState(() {
            preferences.setString(
                'canceledProjects', jsonEncode(canceledProjects));
            preferences.setString(
                'upcomingProjects', jsonEncode(upcomingProjects));
            preferences.setString(
                'completedProjects', jsonEncode(completedProjects));
            preferences.setString(
                'ongoingProjects', jsonEncode(ongoingProjects));
          });
        }
        break;
    }
    if (reminder == true) {
      int? id = preferences.getInt('id');
      LocalNotificationService.showScheduleNotification(
          id: id!,
          title: 'Reminder',
          body: 'Start your ${titleController.text} task now',
          payload: jsonEncode(map),
          scheduleTime: DateTime(
              stringDate.value.year,
              stringDate.value.month,
              stringDate.value.day,
              stringTime.value.hour,
              stringTime.value.minute));
      setState(() {
        preferences.setInt('id', id + 1);
      });
      LocalNotificationService.initialize(context: context, object: map);
    }
    await titleErrorDialog(
        context: context, content: 'success'.tr, isTitle: true);
    AppRoutes.go(AppRouteName.homePage);
  }

  setData() {
    dataModel = DataModel(widget.object);
    titleController = TextEditingController(text: dataModel.title);
    subTitleController = TextEditingController(text: dataModel.subtitle);
    percentageController =
        TextEditingController(text: dataModel.percentage.toString());
    descriptionController = TextEditingController(text: dataModel.description);
    selectedDate.value = dataModel.date;
    selectedTime.value = dataModel.time;
    status = dataModel.status;
    reminder = dataModel.reminder;
  }

  @override
  initState() {
    setData();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    titleController.dispose();
    subTitleController.dispose();
    descriptionController.dispose();
    percentageController.dispose();
  }

  @override
  Widget build(BuildContext context) => EditTaskBody(
      selectedTime: selectedTime,
      selectedDate: selectedDate,
      setTaskData: setTaskData,
      status: status,
      stringDate: stringDate,
      stringTime: stringTime,
      subTitleController: subTitleController,
      descriptionController: descriptionController,
      dropDownValue: dropDown1,
      titleController: titleController,
      percentageController: percentageController,
      reminder: reminder ?? false,
    );
}
