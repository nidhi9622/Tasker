import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/modules/dashboard/helper_widgets/popup_sheet.dart';

import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';
import '../../../models/data_model.dart';

class ProjectItemList extends StatefulWidget {
  const ProjectItemList({Key? key}) : super(key: key);

  @override
  State<ProjectItemList> createState() => _ProjectItemListState();
}

class _ProjectItemListState extends State<ProjectItemList> {
  @override
  Widget build(BuildContext context) => ListView.builder(
    shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projectItem.length,
      itemBuilder: (context, index) {
        DataModel dataModel = DataModel(projectItem[index]);
        return Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 22, right: 22, bottom: 12, top: 6),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                  onTap: () {
                    AppRoutes.go(AppRouteName.projectDetail,
                        arguments: {'object': projectItem[index]});
                  },
                  leading: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: dataModel.percentage! < 100
                                ? Colors.grey
                                : Colors.green),
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      CupertinoIcons.checkmark,
                      color: dataModel.percentage! < 100
                          ? Colors.grey
                          : Colors.green,
                    ),
                  ),
                  title: Text(dataModel.title!),
                  subtitle: LinearPercentIndicator(
                    //leaner progress bar
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 10.0,
                    percent: dataModel.percentage! / 100,
                    progressColor: dataModel.percentage! < 100
                        ? const Color(0xffffb2a6)
                        : Colors.green,
                    barRadius: const Radius.circular(10),
                    backgroundColor: Colors.grey[300],
                  ),
                  trailing: PopupSheet(
                    onTapFirst: () {
                      AppRoutes.pop();
                      AppRoutes.go(AppRouteName.editTask,
                          arguments: {'object': projectItem[index]});
                    },
                    onTapSecond: () async {
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.remove('${dataModel.title}');
                      projectItem.removeWhere(
                          (element) => element['title'] == dataModel.title);
                      upcomingProjects.removeWhere(
                          (element) => element['title'] == dataModel.title);
                      canceledProjects.removeWhere(
                          (element) => element['title'] == dataModel.title);
                      ongoingProjects.removeWhere(
                          (element) => element['title'] == dataModel.title);
                      completedProjects.removeWhere(
                          (element) => element['title'] == dataModel.title);
                      setState(() {
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
                      });
                    },
                  )),
            ));
      },
    );
}
