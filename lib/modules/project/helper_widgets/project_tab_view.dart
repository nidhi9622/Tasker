import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:task_manager/modules/project/helper_widgets/task_detail_container.dart';
import 'package:task_manager/ui_utils/no_task_widget.dart';
import '../../../models/data_model.dart';

class ProjectTabView extends StatefulWidget {
  final Rx tabList;

  const ProjectTabView({Key? key, required this.tabList}) : super(key: key);

  @override
  State<ProjectTabView> createState() => _ProjectTabViewState();
}

class _ProjectTabViewState extends State<ProjectTabView> {
  @override
  Widget build(BuildContext context) => Obx(() {
        return Padding(
          padding: const EdgeInsets.only(left: 14, right: 14),
          child: widget.tabList.value.isNotEmpty
              ? ListView.builder(
                  itemCount: widget.tabList.value.length,
                  itemBuilder: (context, index) {
                    DataModel dataModel =
                        DataModel.fromJson(widget.tabList.value[index]);
                    return TaskDetailContainer(
                      dataModel: dataModel,
                      tabList: widget.tabList.value,
                      index: index,
                    );
                  })
              : const NoTaskWidget(),
        );
      });
}
