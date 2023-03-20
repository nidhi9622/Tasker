import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_utils/helper_methods/project_text_field.dart';
import '../../database/app_list.dart';
import 'heading_text.dart';

class TaskBodyBottom extends StatefulWidget {
  bool reminder;
  int dropDownValue;
  final TextEditingController percentageController;

  TaskBodyBottom(
      {Key? key,
      required this.reminder,
      required this.percentageController,
      required this.dropDownValue})
      : super(key: key);

  @override
  State<TaskBodyBottom> createState() => _TaskBodyBottomState();
}

class _TaskBodyBottomState extends State<TaskBodyBottom> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Column(
      children: [
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
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        hint: Text(dropdownOptions[0]),
                        items: [
                          for (int i = 0; i < dropdownOptions.length; i++)
                            DropdownMenuItem(
                              value: i,
                              child: Text(dropdownOptions[i]),
                            ),
                        ],
                        onChanged: (int? value) {
                          setState(() {
                            widget.dropDownValue = value!;
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
                  value: widget.reminder,
                  onChanged: (value) {
                    setState(() {
                      widget.reminder
                          ? widget.reminder = false
                          : widget.reminder = true;
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
        HeadingText(text: 'percentage'.tr),
        ProjectTextField(
            controller: widget.percentageController,
            labelText: 'percentage'.tr,
            inputType: TextInputType.name,
            inputAction: TextInputAction.next,
            maxLength: 3,
            validator: (String? value) => null,
            maxLines: 1),
        SizedBox(height: deviceSize.height * 0.25),
      ],
    );
  }
}
