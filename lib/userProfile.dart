import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/homePage.dart';
import 'package:task_manager/search.dart';
import 'package:task_manager/settings.dart';
import 'package:task_manager/splashScreen.dart';
import 'package:task_manager/updateUserProfile.dart';
import 'dashboard.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;String? designation;String? map;
  dynamic profileImage;
  getData()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState((){
      name=preferences.getString('name');
      designation=preferences.getString('designation');
    });
    if(preferences.containsKey('imageUrl')){
      setState((){
        profileImage=preferences.getString('imageUrl');  });}
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize=MediaQuery.of(context).size;
    return Scaffold(//bottomNavigationBar: bottomNavigation(context,(int i){setState((){bottomIndex = i;});}, 4),
      appBar: AppBar(actions: [IconButton(onPressed: (){
        showSearch(context: context, delegate: Search(text:''));
        },icon:Icon(Icons.search,color: Theme.of(context).primaryColorDark,))],
        elevation:0,automaticallyImplyLeading:false,title: Text('profile'.tr,style: TextStyle(color: Theme.of(context).primaryColorDark),),),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Stack(
            children: [
              Container(height: 200,color: Theme.of(context).primaryColor,),
              Container(width:deviceSize.width,height: deviceSize.height*0.425,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Theme.of(context).primaryColor),
                child: Column(
                  children: [
                    Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                      SizedBox(width:deviceSize.width*0.20,
                        child: Column(mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                          Text('${projectItem.length}',style: TextStyle(color:Colors.red[200]),),
                          Text('allTask'.tr,style: TextStyle(color: Theme.of(context).primaryColorLight,fontSize: 10),)
                        ],),
                      ),
                      SizedBox(width: deviceSize.width*0.05),SizedBox(width: deviceSize.width*0.40,height: deviceSize.height*0.18,
                          child:Container(
                              height: deviceSize.height/7,
                              width: deviceSize.height/7,
                              decoration: profileImage==null? BoxDecoration(border: Border.all(width:2,color: Colors.black ),
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                      image: AssetImage("assets/personImage.jpg") ,
                                      fit: BoxFit.fill
                                  )
                              ):BoxDecoration(border: Border.all(width:2,color: Colors.black ),
                                  shape: BoxShape.circle,
                                  image:  DecorationImage(
                                      image: FileImage(File(profileImage),scale: 10.0) ,
                                      fit: BoxFit.fill
                                  ))
                          )),
                      SizedBox(width: deviceSize.width*0.05),
                      SizedBox(width:deviceSize.width*0.20,
                        child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                          Text('${ongoingProjects.length}',style:TextStyle(color:Colors.red[200]),),
                          Text('ongoingTask'.tr,style: TextStyle(color: Theme.of(context).primaryColorLight,fontSize: 10),)
                        ],),
                      ),
                    ],),
                    SizedBox(height: deviceSize.height*0.025),
                    Text(name??'name'.tr,style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
                    SizedBox(height: deviceSize.height*0.007),
                    Text(designation??'designation'.tr,style: const TextStyle(fontSize:11,color: Colors.grey),),
                    SizedBox(height: deviceSize.height*0.015),
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const UserProfile()));
                    }, style: ElevatedButton.styleFrom(padding:const EdgeInsets.only(left:34,right: 34),
                      primary:Colors.red[200],
                    ),child:  Text('editProfile'.tr,style:const TextStyle(color: Colors.white),))
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding:const EdgeInsets.only(top: 18,left: 15),
            child: Text('Explore'.tr,style:const TextStyle(fontSize: 19),),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,top: 15),
            child: Row(children: [
              exploreOptions(deviceSize, 'setting'.tr, Icons.settings_outlined,(){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Settings()));},context),
              SizedBox(width: deviceSize.width*0.055),
              exploreOptions(deviceSize, 'allTask'.tr, Icons.table_rows_outlined,(){
                setState(() {
                  selectIndex=1;
                });
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const HomePage()));},context),
              SizedBox(width: deviceSize.width*0.055),
              exploreOptions(deviceSize, 'logOut'.tr, Icons.logout_outlined,()async{
                projectItem.clear();upcomingProjects.clear();ongoingProjects.clear();
                completedProjects.clear();canceledProjects.clear();
                SharedPreferences preferences=await SharedPreferences.getInstance();
                preferences.clear();
                preferences.setInt('id', 0);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SplashScreen()));},context)
            ],),)],),
      ),
    );
  }

}
exploreOptions(dynamic deviceSize,String text,IconData iconData,dynamic onTap,BuildContext context){
  return InkWell(
    onTap: onTap,
    child: Container(width: deviceSize.width*0.26,height: deviceSize.height*0.11,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),color: Theme.of(context).primaryColor),
      child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
        Icon(iconData,color: Colors.red[200],),
        const SizedBox(height: 5,),
        Text(text)
      ],),),
  );
}