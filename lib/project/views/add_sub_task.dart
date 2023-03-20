import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/project/helper_widgets/heading_text.dart';
import 'package:task_manager/project/helper_widgets/hide_container.dart';
import 'package:task_manager/project/helper_widgets/date_time_widget.dart';
import 'package:task_manager/project/views/project_detail.dart';
import '../../app_utils/helper_methods/project_text_field.dart';
import '../../database/app_list.dart';
import '../helper_methods/select_date_time.dart';
import '../helper_methods/title_error_dialog.dart';
import '../../app_utils/local_notification_service.dart';

class AddSubTask extends StatefulWidget {
  final Map object;

  const AddSubTask({Key? key, required this.object}) : super(key: key);

  @override
  State<AddSubTask> createState() => _AddSubTaskState();
}

class _AddSubTaskState extends State<AddSubTask> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController percentageController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  Map map = {};
  bool reminder = true;
  dynamic selectedTime = TimeOfDay.now();
  double titleHeight = 0;
  double subTitleHeight = 0;
  double descriptionHeight = 0;

  @override
  dispose() {
    super.dispose();
    titleController.dispose();
    subTitleController.dispose();
    descriptionController.dispose();
    percentageController.dispose();
  }

  setData() async {
    List subTask = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (percentageController.text.isEmpty) {
      setState(() {
        percentageController.text = '0';
      });
    }
    int newPercentage = int.parse(percentageController.text);
    String date = DateFormat("MMM dd, yyyy").format(selectedDate);
    String time = selectedTime.format(context);
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
    if (preferences.containsKey('${widget.object['title']}')) {
      setState(() {
        String? mapString = preferences.getString('${widget.object['title']}');
        List newMap = jsonDecode(mapString!);
        for (int i = 0; i < newMap.length; i++) {
          subTask.add(newMap[i]);
        }
        if (dropDown1 == 1) {
          map['percentage'] = 100;
          subTask.add(map);
        } else {
          subTask.add(map);
        }
      });
    } else {
      if (dropDown1 == 1) {
        map['percentage'] = 100;
        subTask.add(map);
      } else {
        subTask.add(map);
      }
    }
    setState(() {
      preferences.setString('${widget.object['title']}', jsonEncode(subTask));
    });
    if (reminder == true) {
      int? id = preferences.getInt('id');
      LocalNotificationService.showScheduleNotification(
          id: id!,
          title: '${widget.object['title']} project',
          body: 'Start your ${titleController.text} task now',
          payload: jsonEncode(widget.object),
          scheduleTime: DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, selectedTime.hour, selectedTime.minute));
      setState(() {
        preferences.setInt('id', id + 1);
      });
    }
    LocalNotificationService.initialize(
        context: context, object: widget.object);
  }

  int dropDown1 = 0;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'addTask'.tr,
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
                  if (titleController.text.isEmpty ||
                      subTitleController.text.isEmpty) {
                    await titleErrorDialog(context: context, content: 'error'.tr, isTitle: true);
                  } else {
                    await titleErrorDialog(context: context, content: 'success'.tr, isTitle: true);
                    await setData();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProjectDetail(object: widget.object)));
                  }
                }
              },
              child: Text(
                'done'.tr,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              )),
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
                // SizedBox(height: deviceSize.height*0.02),
                HeadingText(text: 'taskDetail'.tr),
                HideContainer(onTap: () {
                  setState(() {
                    titleHeight = 60;
                  });
                }, text: 'title'.tr),
                if (titleHeight > 0)
                  SizedBox(
                      height: titleHeight,
                      child: ProjectTextField(
                          controller: titleController,
                          labelText: 'title'.tr,
                          inputType: TextInputType.name,
                          inputAction: TextInputAction.next,
                          maxLength: 30,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'titleError'.tr;
                            }
                            return null;
                          },
                          maxLines: 1)),
                HideContainer(onTap: () {
                  setState(() {
                    subTitleHeight = 60;
                  });
                }, text: 'subTitle'.tr),
                if (subTitleHeight > 0)
                  SizedBox(
                    height: subTitleHeight,
                    child: ProjectTextField(
                        controller: subTitleController,
                        labelText: 'subTitle'.tr,
                        inputType: TextInputType.name,
                        inputAction: TextInputAction.next,
                        maxLength: 30,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'subTitleError'.tr;
                          }
                          return null;
                        },
                        maxLines: 1),
                  ),
                SizedBox(height: deviceSize.height * 0.02),
                HeadingText(text: 'startDate'.tr),
                DateTimeWidget(onTap:  () async {
                  final picked=await selectDate(context);
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                    });
                  }
                }, text: DateFormat("MMM dd, yyyy").format(selectedDate), isDate: true,),
                SizedBox(height: deviceSize.height * 0.02),
                HeadingText(text: 'startTime'.tr),
                DateTimeWidget(onTap:  () async {
                  final picked=await selectTime(context);
                  if (picked != null && picked != selectedTime) {
                    setState(() {
                      selectedTime = picked;
                    });
                  }
                }, text: '${selectedTime.format(context)}', isDate: false,),
                SizedBox(
                  height: deviceSize.height * 0.01,
                ),
                HeadingText(text: 'additional'.tr),
                HideContainer(onTap: () {
                  setState(() {
                    descriptionHeight = 120;
                  });
                }, text: 'description'.tr),
                if (descriptionHeight > 0)
                  ProjectTextField(
                      controller: descriptionController,
                      labelText: 'description'.tr,
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      maxLength: 100,
                      validator: (String? value) => null,
                      maxLines: 5),


                ProjectTextField(controller: descriptionController, labelText: 'description'.tr, inputType: TextInputType.name, inputAction: TextInputAction.next, maxLength: 100, validator: (String? value) => null, maxLines:5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
