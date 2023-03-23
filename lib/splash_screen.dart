import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/app_utils/app_routes.dart';
import 'package:task_manager/app_utils/shared_prefs/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
//0xff1c325c
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), ()async{
      await SharedPrefs.init();
      SharedPrefs.setInt(SharedPrefs.userId, 0);
      AppRoutes.pushAndRemoveUntil(AppRouteName.homePage);}
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor:Colors.red[200],
        body: SizedBox(width: double.infinity,height: double.infinity,
          child: Stack(alignment: Alignment.center,
            children: [
            Image.asset(fit: BoxFit.fill,"assets/app.png"),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('Tasker',style: TextStyle(color: Colors.tealAccent,fontSize:40)),
                  SizedBox(height: 10),
                  Text("Best To-Do List App to keep your life on track",
                    style: TextStyle(color: Colors.white60,),)
                ],
              ),
            )
          ],),),
    );
}