import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_manager/models/data_model.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../helper_methods/delete_bottom_sheet.dart';
import 'indicator_widget.dart';

class TaskDetailContainer extends StatefulWidget {
  final DataModel dataModel;
  final List tabList;
  final int index;

  const TaskDetailContainer(
      {Key? key,
      required this.dataModel,
      required this.tabList,
      required this.index})
      : super(key: key);

  @override
  State<TaskDetailContainer> createState() => _TaskDetailContainerState();
}

class _TaskDetailContainerState extends State<TaskDetailContainer> {
  List totalProjectList = [];

  @override
  void initState() {
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      totalProjectList = jsonDecode(map);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => AppRoutes.go(AppRouteName.projectDetail,
            arguments: {'object': widget.tabList[widget.index]}),
        onLongPress: () => deleteBottomSheet(
          context: context,
          title: widget.dataModel.title ?? "",
          index: widget.index,
          onTapEdit: () => AppRoutes.go(AppRouteName.editTask,
              arguments: {'object': totalProjectList[widget.index]}),
          onTapDelete: () async {
            GetPrefs.remove('${widget.dataModel.title}');
            totalProjectList.removeWhere(
                (element) => element['title'] == widget.dataModel.id);
            GetPrefs.setString(GetPrefs.projects, jsonEncode(totalProjectList));
            AppRoutes.pop();
          },
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          width: double.infinity,
          //height: 128,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dataModel.title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.dataModel.subTitle!,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: Colors.grey,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.dataModel.date ?? "",
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
              IndicatorWidget(dataModel: widget.dataModel)
            ],
          ),
        ),
      ));
}
