import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ReminderSettings extends StatefulWidget {
  const ReminderSettings({Key? key}) : super(key: key);

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderSettings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(appBar: AppBar(elevation: 0,
      title: Text('reminderSetting'.tr,style: TextStyle(color: Theme.of(context).primaryColorDark),
    ),leading: IconButton(onPressed: (){
      Navigator.of(context).pop();
    },icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColorDark,),),),
    body: Column(children: const [

    ],),));
  }
}
