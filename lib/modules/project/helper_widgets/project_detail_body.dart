import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_container.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_left.dart';
import 'package:task_manager/modules/project/helper_widgets/project_detail_right.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../../../database/app_list.dart';
import '../../../models/data_model.dart';
import '../controller/project_detail_controller.dart';
import 'custom_tab_bar.dart';

class ProjectDetailBody extends StatefulWidget {
  final Map<String, dynamic> object;

  const ProjectDetailBody({Key? key, required this.object}) : super(key: key);

  @override
  State<ProjectDetailBody> createState() => _ProjectDetailBodyState();
}

class _ProjectDetailBodyState extends State<ProjectDetailBody> {
  late DataModel dataModel;

  ProjectDetailController controller = Get.put(ProjectDetailController());

  getData() async {
    if (GetPrefs.containsKey('${widget.object['id']} notes')) {
      controller.notes.value =
          GetPrefs.getString('${widget.object['id']} notes');
    }
  }

  @override
  initState() {
    dataModel = DataModel.fromJson(widget.object);
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
          child: Column(
        children: [
          ProjectDetailContainer(
            object: widget.object,
            dataModel: dataModel,
          ),
          CustomTabBar(
            tabList: detailedPageTab,
            displayIndex: controller.displayIndex,
          ),
          if (controller.displayIndex.value == 0)
            ProjectDetailLeft(
                object: widget.object,
                subTaskList: controller.subTaskList,
                subTaskProjects: controller.subTaskProjects),
          if (controller.displayIndex.value == 1)
            ProjectDetailRight(
              object: widget.object,
              notesController: controller.notesController.value,
            )
        ],
      ));
}
