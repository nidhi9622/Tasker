import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_utils/helper_methods/project_text_field.dart';
import '../../../database/app_list.dart';
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
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            padding: const EdgeInsets.all(
              14,
            ),
            child: Row(
              children: [
                Text(
                  'status'.tr,
                  style: const TextStyle(fontSize: 18),
                ),
                SizedBox(
                   width: 100,
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
              ],
            )),
        const SizedBox(height: 15),
        Container(
          color: Theme.of(context).primaryColor,
          width: double.infinity,
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
        const SizedBox(height: 15),
        HeadingText(text: 'percentage'.tr),
        ProjectTextField(
            controller: widget.percentageController,
            labelText: 'percentage'.tr,
            inputType: TextInputType.name,
            inputAction: TextInputAction.next,
            maxLength: 3,
            validator: (String? value) => null,
            maxLines: 1),
        const SizedBox(height: 25),
      ],
    );
  }
}
