import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dashboard/views/dashboard.dart';
import '../views/edit_task.dart';

void deleteBottomSheet(
    {required BuildContext context, required Size deviceSize, required String title, required int index,required VoidCallback onTapEdit,required VoidCallback onTapDelete,}) =>
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
              child: SizedBox(
                  height: deviceSize.height * 0.20,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditTask(object: projectItem[index])));
                        },
                        child: ListTile(
                          title: const Text('Edit'),
                          trailing: const Icon(CupertinoIcons.pen),
                          tileColor: Colors.grey[350],
                        ),
                      ),
                      SizedBox(
                        height: deviceSize.height * 0.01,
                      ),
                      InkWell(
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.remove('$title');
                            projectItem.removeWhere(
                                (element) => element['title'] == title);
                            upcomingProjects.removeWhere(
                                (element) => element['title'] == title);
                            canceledProjects.removeWhere(
                                (element) => element['title'] == title);
                            ongoingProjects.removeWhere(
                                (element) => element['title'] == title);
                            completedProjects.removeWhere(
                                (element) => element['title'] == title);
                            //setState(() {
                              preferences.setString(
                                  'projects', jsonEncode(projectItem));
                              preferences.setString('canceledProjects',
                                  jsonEncode(canceledProjects));
                              preferences.setString('upcomingProjects',
                                  jsonEncode(upcomingProjects));
                              preferences.setString('completedProjects',
                                  jsonEncode(completedProjects));
                              preferences.setString('ongoingProjects',
                                  jsonEncode(ongoingProjects));
                           // });
                            Navigator.of(context).pop();
                          },
                          child: ListTile(
                            title: const Text('Delete'),
                            trailing: const Icon(CupertinoIcons.delete),
                            tileColor: Colors.grey[350],
                          )),
                    ],
                  )),
            ));