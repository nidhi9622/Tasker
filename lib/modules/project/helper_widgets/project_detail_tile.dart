import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:task_manager/models/data_model.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../helper_methods/delete_bottom_sheet.dart';

class ProjectDetailTile extends StatefulWidget {
  final DataModel dataModel;
  final List subTaskProjects;
  final int index;
  final Map object;

  const ProjectDetailTile(
      {Key? key,
      required this.dataModel,
      required this.subTaskProjects,
      required this.index,
      required this.object})
      : super(key: key);

  @override
  State<ProjectDetailTile> createState() => _ProjectDetailTileState();
}

class _ProjectDetailTileState extends State<ProjectDetailTile> {
  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () async {
          AppRoutes.go(AppRouteName.editSubTask, arguments: {
            'object': widget.subTaskProjects[widget.index],
            "title": widget.object['title'],
            "homeObject": widget.object,
          });
        },
        trailing: IconButton(
          icon: const Icon(CupertinoIcons.ellipsis_vertical),
          onPressed: () {
            deleteBottomSheet(
              context: context,
              title: widget.dataModel.title ?? "",
              index: widget.index,
              onTapEdit: () {
                //AppRoutes.pop();
                AppRoutes.go(AppRouteName.editSubTask, arguments: {
                  'object': widget.subTaskProjects[widget.index],
                  "title": widget.object['title'],
                  "homeObject": widget.object,
                });
              },
              onTapDelete: () async {
                widget.subTaskProjects.removeWhere(
                    (element) => element['title'] == widget.dataModel.title);
                GetPrefs.setString('${widget.object['title']}',
                    jsonEncode(widget.subTaskProjects));
                AppRoutes.pop();
                // AppRoutes.go(AppRouteName.projectDetail,
                //     arguments: {'object': widget.object});
              },
            );
          },
        ),
        leading: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: widget.dataModel.percentage! < 100
                      ? Colors.grey
                      : Colors.green),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(
            CupertinoIcons.checkmark,
            color:
                widget.dataModel.percentage! < 100 ? Colors.grey : Colors.green,
          ),
        ),
        title: Text(widget.dataModel.title!),
        subtitle: LinearPercentIndicator(
          //leaner progress bar
          animation: true,
          animationDuration: 1000,
          lineHeight: 10.0,
          percent: widget.dataModel.percentage! / 100,
          progressColor: widget.dataModel.percentage! < 100
              ? Colors.red[200]
              : Colors.green,
          barRadius: const Radius.circular(10),
          backgroundColor: Colors.grey[300],
        ),
      );
}
