import 'package:flutter/material.dart';
import 'package:task_manager/modules/project/helper_widgets/task_detail_container.dart';
import 'package:task_manager/ui_utils/no_task_widget.dart';

import '../../../models/data_model.dart';

class ProjectTabView extends StatefulWidget {
  final List tabList;

  const ProjectTabView({Key? key, required this.tabList}) : super(key: key);

  @override
  State<ProjectTabView> createState() => _ProjectTabViewState();
}

class _ProjectTabViewState extends State<ProjectTabView> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: widget.tabList.isNotEmpty
            ? ListView.builder(
                itemCount: widget.tabList.length,
                itemBuilder: (context, index) {
                  DataModel dataModel = DataModel(widget.tabList[index]);
                  return TaskDetailContainer(
                    dataModel: dataModel,
                    tabList: widget.tabList,
                    index: index,
                  );
                })
            : const NoTaskWidget(),
      );
}
