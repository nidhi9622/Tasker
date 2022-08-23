import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/*bottomNavigation(BuildContext context,onTap,int bottomIndex){
  return BottomNavigationBar(
      currentIndex: bottomIndex,type: BottomNavigationBarType.fixed,
      onTap: onTap,//(int i){setState((){bottomIndex = i;});},
      fixedColor: Colors.red[200],
      iconSize: 27,
      selectedFontSize: 2, unselectedFontSize: 2,
      unselectedItemColor: Theme.of(context).primaryColorLight,
      items:
      [BottomNavigationBarItem(icon:IconButton(icon:const Icon(Icons.home),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Dashboard()));
        },),label: ''),
        BottomNavigationBarItem(icon:
            IconButton(icon:const Icon(Icons.list_rounded),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Projects()));
              },), label: ''),
        BottomNavigationBarItem(icon:CircleAvatar(backgroundColor:Colors.red[200],
          child: IconButton(icon: Icon(Icons.add,color: Theme.of(context).primaryColor,),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddProject()));
            },),
        ),label: ''),
        BottomNavigationBarItem(icon:IconButton(icon:const Icon(Icons.note_add_sharp),
          onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const NotePad()));
          },),label: ''),
        BottomNavigationBarItem(icon:IconButton(icon:const Icon(Icons.person_outline),
          onPressed: ()async{
          SharedPreferences preferences=await SharedPreferences.getInstance();
          if(preferences.containsKey('name')){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Profile()));
          }
          else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NewUserProfile()));
          }},),label: ''),

      ]
  );
}*/

addProjectFields(BuildContext context,TextEditingController controller,String labelText,
    TextInputType inputType,TextInputAction inputAction,int maxLength,dynamic validator,int maxLines){
  return Padding(
    padding: const EdgeInsets.only(top: 15,left: 15,right: 15),
    child: TextFormField(controller: controller,
      textInputAction: inputAction,
      keyboardType: inputType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        counterStyle: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        labelText: labelText,labelStyle: const TextStyle(color: Colors.grey),alignLabelWithHint: true,
        focusedBorder:const OutlineInputBorder(borderSide: BorderSide(color:  Color(0xffffb2a6))),
        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColorLight)) ,
        errorMaxLines: 2,errorStyle:const TextStyle(height: 0),
        border: const OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid,color: Color(0xffffb2a6))),
      ),
    ),
  );
}
 List<Tab> tabs = [
  Tab(text: 'all'.tr),
  Tab(text: 'Ongoing'.tr),
  Tab(text: 'Completed'.tr),
];
 List<Tab> detailedPageTab=[
  Tab(text: 'taskList'.tr),
  Tab(text: 'notes'.tr),
];


class DataModel{
  String? title;Map object;
  String? subtitle; int? percentage;String? description;dynamic date;bool? reminder;String? status;
  dynamic time;
  DataModel( this.object){
    title=object['title'];
    subtitle=object['subTitle'];
    percentage=object['percentage'];
    description=object['description'];
    date=object['date'];
    reminder=object['reminder'];
    time=object['time'];
    status=object['status'];
  }
}
appBar(BuildContext context,List<Widget> actions,String text,dynamic leading){
  return AppBar(automaticallyImplyLeading:false,
    elevation:0,title :Text(text,style: TextStyle(color: Theme.of(context).primaryColorDark),),
    leading: leading,
    actions: actions,);
}

List dropdownOptions=['Ongoing'.tr,'Complete'.tr,'Upcoming'.tr,'Canceled'.tr];
