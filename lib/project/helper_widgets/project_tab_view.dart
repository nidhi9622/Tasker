import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/project/helper_widgets/indicator_widget.dart';
import 'package:task_manager/ui_utils/no_task_widget.dart';
import '../../app_utils/app_routes.dart';
import '../../dashboard/views/dashboard.dart';
import '../../models/data_model.dart';
import '../helper_methods/delete_bottom_sheet.dart';

class ProjectTabView extends StatefulWidget {
  final List tabList;

  const ProjectTabView({Key? key, required this.tabList}) : super(key: key);

  @override
  State<ProjectTabView> createState() => _ProjectTabViewState();
}

class _ProjectTabViewState extends State<ProjectTabView> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 14, right: 14),
      child: SizedBox(
        height: deviceSize.height * 0.69,
        child: widget.tabList.isNotEmpty
            ? ListView.builder(
                itemCount: widget.tabList.length,
                itemBuilder: (context, index) {
                  DataModel dataModel = DataModel(widget.tabList[index]);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        AppRoutes.go(AppRouteName.projectDetail,
                            arguments: {'object': widget.tabList[index]});
                      },
                      onLongPress: () {
                        deleteBottomSheet(
                          context: context,
                          deviceSize: deviceSize,
                          title: dataModel.title ?? "",
                          index: index,
                          onTapEdit: () {
                            AppRoutes.go(AppRouteName.editTask,arguments: {
                              'object': projectItem[index]
                            });
                          },
                          onTapDelete: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            preferences.remove('${dataModel.title}');
                            projectItem.removeWhere((element) =>
                                element['title'] == dataModel.title);
                            upcomingProjects.removeWhere((element) =>
                                element['title'] == dataModel.title);
                            canceledProjects.removeWhere((element) =>
                                element['title'] == dataModel.title);
                            ongoingProjects.removeWhere((element) =>
                                element['title'] == dataModel.title);
                            completedProjects.removeWhere((element) =>
                                element['title'] == dataModel.title);
                            setState(() {
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
                            });
                            AppRoutes.pop();
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 18, left: 18, bottom: 18),
                        width: deviceSize.width,
                        height: 128,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor),
                        child: Row(
                          children: [
                            SizedBox(
                              width: deviceSize.width * 0.60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataModel.title!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  SizedBox(height: deviceSize.height * 0.01),
                                  Text(dataModel.subtitle!,
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  SizedBox(height: deviceSize.height * 0.02),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: deviceSize.width * 0.02,
                                      ),
                                      Text(
                                        dataModel.date,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            IndicatorWidget(dataModel: dataModel)
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : const NoTaskWidget(),
      ),
    );
  }
}
