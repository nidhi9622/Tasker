import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import 'package:task_manager/dashboard/views/homePage.dart';
import 'package:task_manager/project/helper_widgets/edit_task_widget.dart';
import 'package:task_manager/project/helper_widgets/heading_text.dart';
import '../../app_utils/helper_methods/project_text_field.dart';
import '../../database/app_list.dart';
import '../../models/data_model.dart';
import '../helper_methods/title_error_dialog.dart';
import '../../dashboard/views/dashboard.dart';
import '../../app_utils/local_notification_service.dart';

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
  Map map = {};
  ValueNotifier selectedDate = ValueNotifier(dynamic);
  ValueNotifier selectedTime = ValueNotifier(dynamic);
  ValueNotifier<DateTime> stringDate = ValueNotifier(DateTime.now());
  ValueNotifier<TimeOfDay> stringTime = ValueNotifier(TimeOfDay.now());
  late DataModel dataModel;
  dynamic timePicked;

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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const HomePage()));
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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return ValueListenableBuilder(
        valueListenable: stringDate,
        builder: (context, value, child) {
          return ValueListenableBuilder(
              valueListenable: selectedDate,
              builder: (context, value, child) {
                return ValueListenableBuilder(
                    valueListenable: selectedTime,
                    builder: (context, value, child) {
                      return ValueListenableBuilder(
                          valueListenable: stringTime,
                          builder: (context, value, child) {
                            return Scaffold(
                              appBar: CommonAppBar(
                                text: 'editTask'.tr, onTap: () async { if (_formKey.currentState!.validate()) {
                                await setTaskData();
                              } },
                              ),
                              body: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        EditTaskWidget(
                                          titleController: titleController,
                                          selectedDate: selectedDate,
                                          stringDate: stringDate,
                                          subTitleController:
                                              subTitleController,
                                          descriptionController:
                                              descriptionController,
                                          stringTime: stringTime,
                                          selectedTime: selectedTime,
                                        ),
                                        SizedBox(
                                            height: deviceSize.height * 0.02),
                                        Container(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: deviceSize.width,
                                            height: deviceSize.height * 0.07,
                                            padding: const EdgeInsets.only(
                                              left: 14,
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'status'.tr,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                SizedBox(
                                                  width:
                                                      deviceSize.width * 0.27,
                                                  height:
                                                      deviceSize.height * 0.06,
                                                  child: Center(
                                                    child: FormField(
                                                        builder: (state) {
                                                      return DropdownButtonFormField(
                                                        decoration:
                                                            const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                        hint: Text(status),
                                                        items: [
                                                          for (int i = 0;
                                                              i <
                                                                  dropdownOptions
                                                                      .length;
                                                              i++)
                                                            DropdownMenuItem(
                                                              value: i,
                                                              child: Text(
                                                                  dropdownOptions[
                                                                      i]),
                                                            ),
                                                        ],
                                                        onChanged:
                                                            (int? value) {
                                                          setState(() {
                                                            dropDown1 = value!;
                                                          });
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                            height: deviceSize.height * 0.03),
                                        Container(
                                          color: Theme.of(context).primaryColor,
                                          width: deviceSize.width,
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            left: 14,
                                          ),
                                          child: Row(
                                            children: [
                                              Transform.scale(
                                                scale: 1.3,
                                                child: Checkbox(
                                                  value: reminder,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      reminder == true
                                                          ? reminder = false
                                                          : reminder = true;
                                                    });
                                                  },
                                                  fillColor:
                                                      MaterialStateProperty.all(
                                                          Colors.red[200]),
                                                ),
                                              ),
                                              Text('reminder'.tr,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: deviceSize.height * 0.025),
                                        HeadingText(text: 'percentage'.tr),
                                        ProjectTextField(
                                            controller: percentageController,
                                            labelText: 'percentage'.tr,
                                            inputType: TextInputType.number,
                                            inputAction: TextInputAction.done,
                                            maxLength: 3,
                                            validator: (String? value) => null,
                                            maxLines: 1),
                                        SizedBox(
                                            height: deviceSize.height * 0.25),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    });
              });
        });
  }
}
