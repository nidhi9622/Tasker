import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/app_utils/app_routes.dart';
import 'package:task_manager/project/helper_widgets/project_detail_tile.dart';
import '../../models/data_model.dart';
import '../../ui_utils/no_task_widget.dart';

class ProjectDetailLeft extends StatefulWidget {
  final Map object;
  final List subTaskList;
  final List subTaskProjects;

  const ProjectDetailLeft(
      {Key? key,
      required this.object,
      required this.subTaskList,
      required this.subTaskProjects})
      : super(key: key);

  @override
  State<ProjectDetailLeft> createState() => _ProjectDetailLeftState();
}

class _ProjectDetailLeftState extends State<ProjectDetailLeft> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return SizedBox(
        height: deviceSize.height * 0.39,
        child: Column(
          children: [
            InkWell(
              onTap: () => AppRoutes.go(AppRouteName.addSubTask,
                  arguments: {"object": widget.object}),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 4, right: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: deviceSize.width * 0.45,
                      child: Row(
                        children: [
                          Text(
                            'addTask'.tr,
                            style: const TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: deviceSize.width * 0.02),
                          CircleAvatar(
                              backgroundColor: Colors.red[200],
                              radius: 13,
                              child: const Icon(
                                CupertinoIcons.add,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                height: deviceSize.height * 0.336,
                padding: const EdgeInsets.only(top: 10),
                child: widget.subTaskList.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.subTaskList.length,
                        itemBuilder: (context, index) {
                          DataModel dataModel =
                              DataModel(widget.subTaskList[index]);
                          return Container(
                              width: deviceSize.width,
                              padding: const EdgeInsets.only(
                                  left: 22, right: 22, bottom: 12, top: 6),
                              child: Container(
                                height: 70,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: ProjectDetailTile(
                                  dataModel: dataModel,
                                  subTaskProjects: widget.subTaskProjects,
                                  index: index,
                                  object: widget.object,
                                ),
                              ));
                        },
                      )
                    : const NoTaskWidget())
          ],
        ));
  }
}
