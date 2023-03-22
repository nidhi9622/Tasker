import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';

void deleteBottomSheet({
  required BuildContext context,
  required String title,
  required int index,
  required VoidCallback onTapEdit,
  required VoidCallback onTapDelete,
}) =>
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      AppRoutes.go(AppRouteName.editTask,
                          arguments: {'object': projectItem[index]});
                    },
                    child: ListTile(
                      title: const Text('Edit'),
                      trailing: const Icon(CupertinoIcons.pen),
                      tileColor: Colors.grey[350],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        preferences.remove(title);
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
                        preferences.setString(
                            'canceledProjects', jsonEncode(canceledProjects));
                        preferences.setString(
                            'upcomingProjects', jsonEncode(upcomingProjects));
                        preferences.setString(
                            'completedProjects', jsonEncode(completedProjects));
                        preferences.setString(
                            'ongoingProjects', jsonEncode(ongoingProjects));
                        // });
                        AppRoutes.pop();
                      },
                      child: ListTile(
                        title: const Text('Delete'),
                        trailing: const Icon(CupertinoIcons.delete),
                        tileColor: Colors.grey[350],
                      )),
                ],
              ),
            ));
