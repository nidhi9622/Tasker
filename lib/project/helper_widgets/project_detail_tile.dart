import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/models/data_model.dart';
import '../helper_methods/delete_bottom_sheet.dart';
import '../views/edit_sub_task.dart';
import '../views/project_detail.dart';

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
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return ListTile(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditSubTask(
                  object: widget.subTaskProjects[widget.index],
                  title: widget.object['title'],
                  homeObject: widget.object,
                )));
      },
      trailing: IconButton(
        icon: const Icon(CupertinoIcons.ellipsis_vertical),
        onPressed: () {
          deleteBottomSheet(
            context: context,
            deviceSize: deviceSize,
            title: widget.dataModel.title ?? "",
            index: widget.index,
            onTapEdit: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditSubTask(
                        object: widget.subTaskProjects[widget.index],
                        title: widget.object['title'],
                        homeObject: widget.object,
                      )));
            },
            onTapDelete: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              setState(() {
                widget.subTaskProjects.removeWhere(
                    (element) => element['title'] == widget.dataModel.title);
                preferences.setString('${widget.object['title']}',
                    jsonEncode(widget.subTaskProjects));
              });
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProjectDetail(object: widget.object)));
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
        progressColor:
            widget.dataModel.percentage! < 100 ? Colors.red[200] : Colors.green,
        barRadius: const Radius.circular(10),
        backgroundColor: Colors.grey[300],
      ),
    );
  }
}
