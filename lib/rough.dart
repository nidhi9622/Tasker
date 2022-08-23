import 'package:flutter/material.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/projects.dart';
class Rough extends StatelessWidget {
  const Rough({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(
        onPressed: (){
          Navigator.of(context).push(CustomRoute(child:const Projects(), type: slideTransition2));
        },child:const Text('Press'),
      ),),
    );
  }
}
