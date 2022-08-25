import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/homePage.dart';
import 'package:task_manager/reusables.dart';
import 'dashboard.dart';
import 'notificationApi.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final TextEditingController title=TextEditingController();
  final TextEditingController subTitle=TextEditingController();
  final TextEditingController description=TextEditingController();
  final TextEditingController percentage=TextEditingController();
  List tasks=[];List ongoingTask=[];List completedTasks=[];List upcomingTasks=[];List canceledTasks=[];
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  DateTime selectedDate =DateTime.now();
  Map map={};List projectList=[];
  bool reminder=true;dynamic selectedTime=TimeOfDay.now();
  double titleHeight=0;double subTitleHeight=0;double descriptionHeight=0;double percentageHeight=0;
  bool preExist=false;
  setData()async{
    if(percentage.text.isEmpty){
      setState(() {
        percentage.text='0';
      });
    }
    int newPercentage =int.parse(percentage.text);
    String date=DateFormat("MMM dd, yyyy").format(selectedDate);
    String time=selectedTime.format(context);
    for(int i=0;i<projectItem.length;i++){

    }
    setState((){
      map={
        'title':title.text,'subTitle':subTitle.text,'description':description.text,
        'percentage':newPercentage,'date':date,'reminder':reminder,'time':time,
        'status':dropdownOptions[dropDown1],
      };
    });

    SharedPreferences preferences=await SharedPreferences.getInstance();
    String? mapString;List projectList=[];List newMap;
    if(preferences.containsKey('projects')){
        mapString=preferences.getString('projects');
        newMap=jsonDecode(mapString!);
        for(int i=0;i<newMap.length;i++){
          if(title.text.removeAllWhitespace==newMap[i]['title']){
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
      print('already exist');
      titleErrorDialog(context);
    }
    else{
    if(preferences.containsKey('projects')){
      setState((){
        mapString=preferences.getString('projects');
        newMap=jsonDecode(mapString!);
        for(int i=0;i<newMap.length;i++){
          //print('title is : ${newMap[i]['title']}');
          projectList.add(newMap[i]);
        }
        projectList.add(map);
      });
    } 
    else{
      setState((){
        projectList.add(map);
      });
    }
    setState((){preferences.setString('projects', jsonEncode(projectList)); });
    switch(dropDown1){
      case 0:{
        String? mapStringOnGoing;List newMapOngoing;
        if(preferences.containsKey('ongoingProjects')){
          mapStringOnGoing=preferences.getString('ongoingProjects');
          newMapOngoing=jsonDecode(mapStringOnGoing!);
            for(int i=0;i<newMapOngoing.length;i++){
              ongoingTask.add(newMapOngoing[i]);
            }
            ongoingTask.add(map);
        }
        else{
            ongoingTask.add(map);
        }
        String totalProjects=jsonEncode(ongoingTask);
        setState(() {
          preferences.setString('ongoingProjects', totalProjects);
        });
      }
      break;
      case 1:{
        String? mapStringCompleted;List newMapCompleted;
        if(preferences.containsKey('completedProjects')){
          mapStringCompleted=preferences.getString('completedProjects');
          newMapCompleted=jsonDecode(mapStringCompleted!);
        for(int i=0;i<newMapCompleted.length;i++){
          completedTasks.add(newMapCompleted[i]);
        }
        map['percentage']=100;
        completedTasks.add(map);
      }
      else{
        map['percentage']=100;
        completedTasks.add(map);
        projectList[projectList.indexWhere((element) => element['title'] == title.text)] = map;
      }
      setState(() {
        preferences.setString('completedProjects', jsonEncode(completedTasks));
        preferences.setString('projects', jsonEncode(projectList));
      });
      }break;
      case 2:{
        String? mapStringUpcoming;List newMapUpcoming;
        if(preferences.containsKey('upcomingProjects')){
          mapStringUpcoming=preferences.getString('upcomingProjects');
          newMapUpcoming=jsonDecode(mapStringUpcoming!);
        for(int i=0;i<newMapUpcoming.length;i++){
          upcomingTasks.add(newMapUpcoming[i]);
        }
        upcomingTasks.add(map);
      }
      else{
        upcomingTasks.add(map);
      }
      String totalProjects=jsonEncode(upcomingTasks);
      setState(() {
        preferences.setString('upcomingProjects', totalProjects);
      });
      }break;
      case 3:{
        String? mapStringCanceled;List newMapCanceled;
        if(preferences.containsKey('canceledProjects')){
          mapStringCanceled=preferences.getString('canceledProjects');
          newMapCanceled=jsonDecode(mapStringCanceled!);
        for(int i=0;i<newMapCanceled.length;i++){
          canceledTasks.add(newMapCanceled[i]);
        }
        canceledTasks.add(map);
      }
      else{
        canceledTasks.add(map);
      }
      String totalProjects=jsonEncode(canceledTasks);
      setState(() {
        preferences.setString('canceledProjects', totalProjects);
      });
      }break;
    }
    if(reminder){
      int? id=preferences.getInt('id');
    LocalNotificationService.showScheduleNotification(
        id: id!,
        title: 'Reminder',
        body: 'Start your ${title.text} task now',
        payload: jsonEncode(map),
        scheduleTime:DateTime(selectedDate.year,selectedDate.month,selectedDate.day,selectedTime.hour,selectedTime.minute)
    );
    setState(() {
      preferences.setInt('id', id+1);});}
    LocalNotificationService.initialize(context:context,object: map);
    await showDialogBox(context,'success'.tr);
    setState(() {
      selectIndex=0;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));}
  }
  int dropDown1=0;
  @override
  Widget build(BuildContext context) {
    final deviceSize=MediaQuery.of(context).size;
    return Scaffold(
        //bottomNavigationBar: bottomNavigation(context, (int i){setState((){bottomIndex = i;});}, 2),
        appBar: AppBar(elevation:0,title :Text('newProject'.tr,style: TextStyle(color: Theme.of(context).primaryColorDark),),
          automaticallyImplyLeading: false,actions: [
            TextButton(onPressed: ()async{
              if(_formKey.currentState!.validate()){
                if(title.text.isEmpty ||subTitle.text.isEmpty ){
                  await  showDialogBox(context,'error'.tr);}
                else{
                await setData();

              }}
            }, child: Text('done'.tr,style: TextStyle(color: Theme.of(context).primaryColorDark),)),
          ],),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heading('projectDetail'.tr, deviceSize),
                  hideContainer('title'.tr, deviceSize, (){setState(() {titleHeight=60;});}),
                  if(titleHeight>0)
                  SizedBox(height: titleHeight,child:
                    addProjectFields(context, title, 'title'.tr, TextInputType.name, TextInputAction.next, 30, (String? value){
                      if (value!.isEmpty) {return 'titleError'.tr;}
                      return null;
                    }, 1)),
                  hideContainer('subTitle'.tr, deviceSize, (){setState(() {subTitleHeight=60;});}),
                  if(subTitleHeight>0)
                  SizedBox(height: subTitleHeight,child:
                    addProjectFields(context, subTitle, 'subTitle'.tr, TextInputType.name, TextInputAction.next, 30, (String? value){
                      if (value!.isEmpty) {return 'subTitleError'.tr;}
                      return null;
                    }, 1)),
                  SizedBox(height: deviceSize.height*0.02),
                  heading('startDate'.tr,deviceSize),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap:()async{
                        await _selectDate(context);},
                      child: Container(padding:const EdgeInsets.only(left: 17),
                        width: deviceSize.width,height: 50,decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color:  Theme.of(context).primaryColor
                      ),
                         child: Row(children: [
                           Icon(Icons.calendar_month_outlined,color: Theme.of(context).primaryColorDark,),
                           SizedBox(width: deviceSize.width*0.02),
                           Text(DateFormat("MMM dd, yyyy").format(selectedDate))
                         ],),),
                    ),
                  ),
                  SizedBox(height: deviceSize.height*0.02),
                  heading('startTime'.tr,deviceSize),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap:()async{
                        await _selectTime(context);},
                      child: Container(padding:const EdgeInsets.only(left: 17),
                        width: deviceSize.width,height: 50,decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor
                        ),
                        child: Row(children: [
                          Icon(Icons.more_time,color: Theme.of(context).primaryColorDark,),
                          SizedBox(width: deviceSize.width*0.025),
                          Text('${selectedTime.format(context)}')
                        ],),),
                    ),
                  ),
                  SizedBox(height: deviceSize.height*0.01,),
                  heading('additional'.tr,deviceSize),
                  hideContainer('description'.tr, deviceSize, (){setState(() {descriptionHeight=120;});}),
                  if(descriptionHeight>0)
                  SizedBox(height: descriptionHeight,child:
                    addProjectFields(context, description, 'description'.tr, TextInputType.name, TextInputAction.next, 100, (String? value){}, 5)),
                  SizedBox(height: deviceSize.height*0.02),
                  Container(color: Theme.of(context).primaryColor,width: deviceSize.width,height: deviceSize.height*0.07,
                      padding: const EdgeInsets.only(left: 14,),
                      child: Row(children: [
                        Text('status'.tr,style: const TextStyle(fontSize: 18),),
                        SizedBox(width: deviceSize.width*0.27,height: deviceSize.height*0.06,
                          child: Center(
                            child: FormField(builder:(state){
                                return
                                  DropdownButtonFormField(
                                    decoration: const InputDecoration(border: InputBorder.none),
                                    hint:Text(dropdownOptions[0]),items:[
                                    for(int i=0;i<dropdownOptions.length;i++)
                                      DropdownMenuItem(value: i,child: Text(dropdownOptions[i]),),
                                  ], onChanged: (int? value){
                                    setState(() {
                                      dropDown1=value!;
                                    });
                                  },);}),
                          ),
                          ),
                      ],)
                  ),
                  SizedBox(height: deviceSize.height*0.03),
                  Container(color: Theme.of(context).primaryColor,width: deviceSize.width,height: 50,
                    padding: const EdgeInsets.only(left: 14,),
                    child: Row(
                        children: [
                          Transform.scale(
                            scale: 1.3,
                            child: Checkbox(value: reminder, onChanged: (value){
                              setState(() {
                                reminder?reminder=false:reminder=true;
                              });
                            },
                            fillColor:  MaterialStateProperty.all(Colors.red[200]),),
                          ),
                          Text('reminder'.tr,style: const TextStyle(fontSize: 18,)),
                        ],
                      ),
                    ),
                  SizedBox(height: deviceSize.height*0.025),
                  heading('percentage'.tr,deviceSize),
                  SizedBox(child:
                  addProjectFields(context, percentage, 'percentage'.tr, TextInputType.number, TextInputAction.done, 3, (String? value){}, 1)),
                  SizedBox(height: deviceSize.height*0.25),

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

    final dynamic picked = await showTimePicker(
        initialTime: TimeOfDay.now(),
        context: context);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }
  heading(String text,dynamic deviceSize){
    return Container(color: Theme.of(context).primaryColor,width: deviceSize.width,height: 50,
        padding: const EdgeInsets.only(top: 13,left: 14,),
        child: Text(text,style:const TextStyle(
          fontSize:18,),
        )
    );
  }
  hideContainer(String text,dynamic deviceSize,dynamic onTap){
    return InkWell(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.only(left: 10,top:10,right: 10),
          child: Container(width: deviceSize.width,height:30,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),color: Theme.of(context).primaryColor),
            child: Row(
              children:  [
                CircleAvatar(backgroundColor: Colors.red[200],radius: 9,child: Icon(Icons.add,color: Theme.of(context).primaryColor,size: 17,),),
                SizedBox(width: deviceSize.width*0.015),
                Text(text,),
               ],
          ),
          ),
      ),
    );
  }
}
showDialogBox(BuildContext context,String text){
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Update'.tr),
        content:  Text(text),
        actions: [
          TextButton(
            child:Center(child: Text('ok'.tr)),
            onPressed: () {Navigator.of(context).pop();},
          ),
        ],
      );
    },
  );
}
titleErrorDialog(BuildContext context){
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        //title: Text('Update'.tr),
        content:const Text('Project with this title already exist.\nPlease try with another title.'),
        actions: [
          TextButton(
            child:Center(child: Text('ok'.tr)),
            onPressed: () {Navigator.of(context).pop();},
          ),
        ],
      );
    },
  );
}