import 'package:flutter/cupertino.dart';
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

int selectIndex = 0;

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  PageController pageController = PageController();
  List<Widget> screens = [
    const Dashboard(),
    const Projects(),
    const AddProject(),
    const NotePad()
  ];

  int oldIndex = 0;

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
    } else {
      setState(() {
        screens.insert(4, const NewUserProfile());
      });
    }
  }

  void onTap(int index) {
    setState(() {
      oldIndex = selectIndex;
      selectIndex = index;
    });
    // when using page view
    /*pageController.animateToPage(index,
          duration:const Duration(milliseconds: 300), curve: Curves.easeOut);*/
    //  pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  late AnimationController controller;
  late Animation<double> animation;

  @override
  initState() {
    isProfileExist();
    super.initState();
  }

  transition() {
    double position = 1.0;
    if (oldIndex < selectIndex) {
      setState(() {
        position = 1.0;
      });
    } else {
      setState(() {
        position = -1.0;
      });
    }
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = CurvedAnimation(curve: Curves.easeIn, parent: controller);
    return AnimatedSwitcher(
      switchOutCurve: Curves.decelerate,
      reverseDuration: const Duration(milliseconds: 0),
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SlideTransition(
          position: Tween(
            begin: Offset(position, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
      child: screens[selectIndex],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectIndex,
            type: BottomNavigationBarType.fixed,
            onTap: onTap,
            iconSize: 27,
            selectedLabelStyle: TextStyle(color: Colors.red[200]),
            selectedFontSize: 0,
            selectedItemColor: Colors.red[200],
            unselectedFontSize: 1,
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.home,
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.doc,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                    backgroundColor: Colors.red[200],
                    child: Icon(
                      CupertinoIcons.add,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.news,
                  ),
                  label: ''),
              const BottomNavigationBarItem(
                  icon: Icon(
                    CupertinoIcons.person,
                  ),
                  label: ''),
            ]),
        body: transition()

        // From animation package
        /* PageTransitionSwitcher(
      duration: const Duration(seconds: 1),
      child: screens[selectIndex],
      transitionBuilder: (child,animation,secondaryAnimation)=>
          SharedAxisTransition(animation: animation, secondaryAnimation: secondaryAnimation, transitionType: SharedAxisTransitionType.horizontal,child: child,),
    ) */
        /*PageView(
   //  physics:const ScrollPhysics(parent: NeverScrollableScrollPhysics()),
      controller: pageController,
      onPageChanged: onPageChanged,
      //scrollDirection: Axis.horizontal,
      children: screens,
    ),*/
        );
  }
}
