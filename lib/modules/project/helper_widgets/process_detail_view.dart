import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/modules/project/helper_widgets/task_detail_container.dart';
import 'package:task_manager/ui_utils/no_task_widget.dart';

import '../../../models/data_model.dart';

class ProcessDetailView extends StatelessWidget {
  final List tabList;

  const ProcessDetailView({Key? key, required this.tabList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: tabList.isNotEmpty
            ? ListView.builder(
                itemCount: tabList.length,
                itemBuilder: (context, index) {
                  DataModel dataModel = DataModel(tabList[index]);
                  return TaskDetailContainer(
                    dataModel: dataModel,
                    tabList: tabList,
                    index: index,
                  );
                })
            : const NoTaskWidget(),
      ),
    );
  }
}
