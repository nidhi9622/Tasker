import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/project/views/project_detail.dart';
import '../../app_utils/helper_methods/project_text_field.dart';
import '../../database/app_list.dart';
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
                heading('taskDetail'.tr, deviceSize),
                hideContainer('title'.tr, deviceSize, () {
                  setState(() {
                    titleHeight = 60;
                  });
                }),
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
                hideContainer('subTitle'.tr, deviceSize, () {
                  setState(() {
                    subTitleHeight = 60;
                  });
                }),
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
                          Text(DateFormat("MMM dd, yyyy").format(selectedDate))
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
                          Text('${selectedTime.format(context)}')
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.01,
                ),
                heading('additional'.tr, deviceSize),
                hideContainer('description'.tr, deviceSize, () {
                  setState(() {
                    descriptionHeight = 120;
                  });
                }),
                if (descriptionHeight > 0)
                  ProjectTextField(
                      controller: descriptionController,
                      labelText: 'description'.tr,
                      inputType: TextInputType.name,
                      inputAction: TextInputAction.next,
                      maxLength: 100,
                      validator: (String? value) => null,
                      maxLines: 5),
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
                                hint: Text(dropdownOptions[0]),
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
                              reminder ? reminder = false : reminder = true;
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
                ProjectTextField(
                    controller: percentageController,
                    labelText: 'percentage'.tr,
                    inputType: TextInputType.name,
                    inputAction: TextInputAction.next,
                    maxLength: 3,
                    validator: (String? value) => null,
                    maxLines: 1),
                SizedBox(height: deviceSize.height * 0.25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  _selectTime(BuildContext context) async {
    final dynamic picked =
        await showTimePicker(initialTime: TimeOfDay.now(), context: context);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
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
