import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import 'package:task_manager/project/helper_widgets/edit_task_widget.dart';
import '../../app_utils/app_routes.dart';
import '../../database/app_list.dart';
import '../../models/data_model.dart';
import '../helper_methods/title_error_dialog.dart';
import '../../app_utils/local_notification_service.dart';

class EditSubTask extends StatefulWidget {
  final Map object;
  final String title;
  final Map homeObject;

  const EditSubTask(
      {Key? key,
      required this.object,
      required this.title,
      required this.homeObject})
      : super(key: key);

  @override
  State<EditSubTask> createState() => _EditSubTaskState();
}

class _EditSubTaskState extends State<EditSubTask> {
  late TextEditingController titleController;
  late TextEditingController subTitleController;
  late TextEditingController percentageController;
  late TextEditingController descriptionController;

  @override
  dispose() {
    super.dispose();
    titleController.dispose();
    subTitleController.dispose();
    descriptionController.dispose();
    percentageController.dispose();
  }

  int dropDown1 = 0;
  List tasks = [];
  List ongoingTask = [];
  List completedTasks = [];
  List upcomingTasks = [];
  List canceledTasks = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool? reminder;
  List optionList = [];
  dynamic status;
  bool preExist = false;
  ValueNotifier selectedDate = ValueNotifier(dynamic);
  ValueNotifier selectedTime = ValueNotifier(dynamic);
  ValueNotifier<DateTime> stringDate = ValueNotifier(DateTime.now());
  ValueNotifier<TimeOfDay> stringTime = ValueNotifier(TimeOfDay.now());
  late DataModel dataModel;
  dynamic timePicked;
  dynamic datePicked;
  String? subTask;
  List subTaskProjects = [];
  Map map = {};

  setTaskData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey(widget.title)) {
      subTask = preferences.getString(widget.title);
      setState(() {
        subTaskProjects = jsonDecode(subTask!);
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
        'time': selectedTime,
        'status': dropdownOptions[dropDown1],
      };
    });
    if (dropDown1 == 1) {
      map['percentage'] = 100;
      subTaskProjects[subTaskProjects
          .indexWhere((element) => element['title'] == dataModel.title)] = map;
    } else {
      subTaskProjects[subTaskProjects
          .indexWhere((element) => element['title'] == dataModel.title)] = map;
    }
    setState(() {
      preferences.setString(widget.title, jsonEncode(subTaskProjects));
    });
    if (reminder == true) {
      int? id = preferences.getInt('id');
      LocalNotificationService.showScheduleNotification(
          id: id!,
          title: 'Reminder',
          body: 'Start your ${titleController.text} task now',
          payload: jsonEncode(widget.homeObject),
          scheduleTime: DateTime(
              stringDate.value.year,
              stringDate.value.month,
              stringDate.value.day,
              stringTime.value.hour,
              stringTime.value.minute));
      setState(() {
        preferences.setInt('id', id + 1);
      });
    }
    LocalNotificationService.initialize(
        context: context, object: widget.homeObject);
    await titleErrorDialog(
        context: context, content: 'success'.tr, isTitle: true);
    AppRoutes.go(AppRouteName.projectDetail,
        arguments: {'object': widget.homeObject});
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
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: stringDate,
      builder: (context, value, child) => ValueListenableBuilder(
          valueListenable: selectedDate,
          builder: (context, value, child) => ValueListenableBuilder(
              valueListenable: selectedTime,
              builder: (context, value, child) => ValueListenableBuilder(
                  valueListenable: stringTime,
                  builder: (context, value, child) {
                    return Scaffold(
                      appBar: CommonAppBar(
                        text: 'editSubTask'.tr,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await setTaskData();
                          }
                        },
                        isLeading: true,
                        isAction: true,
                      ),
                      body: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: EditTaskWidget(
                            titleController: titleController,
                            selectedDate: selectedDate,
                            stringDate: stringDate,
                            subTitleController: subTitleController,
                            descriptionController: descriptionController,
                            stringTime: stringTime,
                            selectedTime: selectedTime,
                          ),
                        ),
                      ),
                    );
                  }))));
}
