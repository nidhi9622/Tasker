import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/newUserProfile.dart';
import 'package:task_manager/projects.dart';
import 'package:task_manager/userProfile.dart';
import 'addProject.dart';
import 'dashboard.dart';
import 'notepad.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  List<Widget> screens = [
    const Dashboard(),
    const Projects(),
    const AddProject(),
    const NotePad()
  ];
  int selectIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void isProfileExist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('name')) {
      setState(() {
        screens.insert(4, const Profile());
      });
    }
    else {
      setState(() {
        screens.insert(4, const NewUserProfile());
      });
    }
  }

  void onTap(int index) {
    setState(() {
      selectIndex = index;
      // pageController.animateToPage(selectIndex,
      //     duration:const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
   /* Navigator.of(context).push(
        CustomRoute(child: screens[selectIndex], type: fadeTransition));*/
     pageController.jumpToPage(index);

     print(pageController);
  }

   void onPageChanged(int index){
    setState(() {
      selectIndex=index;

    });
  }
  late AnimationController controller;
 late Animation<double> animation;

  @override
  initState() {
    isProfileExist();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    animation=CurvedAnimation(parent: controller, curve: Curves.easeIn);
   //controller.repeat(reverse: true);

     Timer(const Duration(seconds: 1), () {
       if(controller.isCompleted)
       controller.dispose();
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        iconSize: 27,
        selectedLabelStyle: TextStyle(color: Colors.red[200]),
        selectedFontSize: 0,selectedItemColor: Colors.red[200],
        unselectedFontSize: 1,
        items: [const BottomNavigationBarItem(icon: Icon(Icons.home,), label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.list_rounded,),label: ''),
          BottomNavigationBarItem(
              icon: CircleAvatar(backgroundColor: Colors.red[200],
                child: Icon(Icons.add, color: Theme.of(context).primaryColor,),), label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.note_add_sharp,),label: ''),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline,), label: ''),
        ]
    ), body: /*SlideTransition(position:  Tween<Offset>(
        begin: const Offset (0,-1),
        end: Offset.zero
    ).animate(animation),child: screens[selectIndex],) */PageView(
   //  physics:const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      controller: pageController,
      onPageChanged: onPageChanged,
      //scrollDirection: Axis.horizontal,
      children: screens,
    ),
    );
  }
}