import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_manager/app_utils/app_routes.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_tile.dart';

import '../../../models/data_model.dart';
import '../../../ui_utils/no_task_widget.dart';

class ProjectDetailLeft extends StatefulWidget {
  final Map object;
  final Rx<List> subTaskList;
  final Rx<List> subTaskProjects;

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
    return Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 4, right: 15),
              child: InkWell(
                onTap: () => AppRoutes.go(AppRouteName.addSubTask,
                    arguments: {"object": widget.object}),
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'addTask'.tr,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
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
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: widget.subTaskList.value.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.subTaskList.value.length,
                        itemBuilder: (context, index) {
                          DataModel dataModel =
                              DataModel.fromJson(widget.subTaskList.value[index]);
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 22, right: 22, bottom: 12, top: 6),
                              child: Container(
                                // height: 70,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(12)),
                                child: ProjectDetailTile(
                                  dataModel: dataModel,
                                  subTaskProjects: widget.subTaskProjects.value,
                                  index: index,
                                  object: widget.object,
                                ),
                              ));
                        },
                      )
                    : const NoTaskWidget())
          ],
        );
      }
    );
  }
}
