import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/dashboard/views/homePage.dart';
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
  dynamic selectedDate;
  bool? reminder;
  dynamic selectedTime;
  List optionList = [];
  dynamic status;
  bool preExist = false;
  Map map = {};
  DateTime stringDate = DateTime.now();
  TimeOfDay stringTime = TimeOfDay.now();
  late DataModel dataModel;
  dynamic timePicked;
  dynamic datePicked;
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
        'date': selectedDate,
        'reminder': reminder,
        'time': selectedTime,
        'status': dropdownOptions[dropDown1],
      };
    });

    /* if(preferences.containsKey('projects')){
      for(int i=0;i<optionList.length;i++){
        if(titleController.text.removeAllWhitespace==optionList[i]['title']){
          setState(() {
            preExist=true;
          });
        }
        else{
          setState(() {
            preExist=false;
          });
        }
      }
    }
    if(preExist==true){
      titleErrorDialog(context);
    }
    else{*/
    optionList[optionList
        .indexWhere((element) => element['title'] == dataModel.title)] = map;

    //optionList.removeWhere((element) => element['title'] == dataModel.title);
    //optionList.add(map);
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
            preferences.setString('${widget.object['title']}', jsonEncode(list));
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
          scheduleTime: DateTime(stringDate.year, stringDate.month,
              stringDate.day, stringTime.hour, stringTime.minute));
      setState(() {
        preferences.setInt('id', id + 1);
      });
      LocalNotificationService.initialize(context: context, object: map);
    }
    await titleErrorDialog(context: context, content: 'success'.tr, isTitle: true);
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
    selectedDate = dataModel.date;
    selectedTime = dataModel.time;
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'editTask'.tr,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await setTaskData();
                }
              },
              child: Text(
                'done'.tr,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                heading('taskDetail'.tr, deviceSize),
                ProjectTextField(controller: titleController, labelText: 'title'.tr, inputType: TextInputType.name, inputAction: TextInputAction.next, maxLength: 30, validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'titleError'.tr;
                  }
                  return null;
                }, maxLines:1),
                ProjectTextField(controller: subTitleController, labelText: 'subTitle'.tr, inputType: TextInputType.name, inputAction: TextInputAction.next, maxLength: 30, validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'subTitleError'.tr;
                  }
                  return null;
                }, maxLines:1),
                SizedBox(height: deviceSize.height * 0.02),
                heading('startDate'.tr, deviceSize),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () async {
                      await _selectDate(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 17),
                      width: deviceSize.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(width: deviceSize.width * 0.02),
                          Text(selectedDate)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                heading('startTime'.tr, deviceSize),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () async {
                      await _selectTime(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 17),
                      width: deviceSize.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor),
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.time_solid,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          SizedBox(width: deviceSize.width * 0.025),
                          Text('$selectedTime')
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.01,
                ),
                heading('additional'.tr, deviceSize),
                ProjectTextField(controller: descriptionController, labelText: 'description'.tr, inputType: TextInputType.name, inputAction: TextInputAction.next, maxLength: 100, validator: (String? value) => null, maxLines:5),
                SizedBox(height: deviceSize.height * 0.02),
                Container(
                    color: Theme.of(context).primaryColor,
                    width: deviceSize.width,
                    height: deviceSize.height * 0.07,
                    padding: const EdgeInsets.only(
                      left: 14,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'status'.tr,
                          style: const TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: deviceSize.width * 0.27,
                          height: deviceSize.height * 0.06,
                          child: Center(
                            child: FormField(builder: (state) {
                              return DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                hint: Text(status),
                                items: [
                                  for (int i = 0;
                                      i < dropdownOptions.length;
                                      i++)
                                    DropdownMenuItem(
                                      value: i,
                                      child: Text(dropdownOptions[i]),
                                    ),
                                ],
                                onChanged: (int? value) {
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
                SizedBox(height: deviceSize.height * 0.03),
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
                          fillColor: MaterialStateProperty.all(Colors.red[200]),
                        ),
                      ),
                      Text('reminder'.tr,
                          style: const TextStyle(
                            fontSize: 18,
                          )),
                    ],
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.025),
                heading('percentage'.tr, deviceSize),
                ProjectTextField(controller: percentageController, labelText: 'percentage'.tr, inputType: TextInputType.number, inputAction: TextInputAction.done, maxLength: 3, validator: (String? value) => null, maxLines:1),
                SizedBox(height: deviceSize.height * 0.25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (datePicked != null && datePicked != selectedDate) {
      setState(() {
        stringDate = datePicked;
        selectedDate = DateFormat("MMM dd, yyyy").format(datePicked);
      });
    }
  }

  _selectTime(BuildContext context) async {
    timePicked =
        await showTimePicker(initialTime: TimeOfDay.now(), context: context);
    if (timePicked != null && timePicked != selectedTime) {
      setState(() {
        selectedTime = timePicked.format(context);
        stringTime = timePicked;
      });
    }
  }

  heading(String text, dynamic deviceSize) {
    return Container(
        color: Theme.of(context).primaryColor,
        width: deviceSize.width,
        height: 50,
        padding: const EdgeInsets.only(
          top: 13,
          left: 14,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
          ),
        ));
  }

  hideContainer(String text, dynamic deviceSize, dynamic onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Container(
          width: deviceSize.width,
          height: 30,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Theme.of(context).primaryColor),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[200],
                radius: 9,
                child: Icon(
                  CupertinoIcons.add,
                  color: Theme.of(context).primaryColor,
                  size: 17,
                ),
              ),
              SizedBox(width: deviceSize.width * 0.015),
              Text(
                text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
