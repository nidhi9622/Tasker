import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app_utils/shared_prefs/get_prefs.dart';
import 'package:task_manager/modules/project/helper_widgets/task_detail_container.dart';
import 'package:task_manager/ui_utils/no_task_widget.dart';
import '../../../models/data_model.dart';

class ProcessDetailView extends StatefulWidget {
  final String tabList;

  const ProcessDetailView({Key? key, required this.tabList}) : super(key: key);

  @override
  State<ProcessDetailView> createState() => _ProcessDetailViewState();
}

class _ProcessDetailViewState extends State<ProcessDetailView> {
  List processList=[];
  @override
  void initState() {
    String string=GetPrefs.getString(GetPrefs.projects);
    List newList=jsonDecode(string);
    for(int i=0;i<newList.length;i++){
      if(newList[i]["projectStatus"]==widget.tabList){
        processList.add(newList[i]);
      }
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: processList.isNotEmpty
            ? ListView.builder(
                itemCount:processList.length,
                itemBuilder: (context, index) {
                  DataModel dataModel = DataModel.fromJson(processList[index]);
                  return TaskDetailContainer(
                    dataModel: dataModel,
                    tabList: processList,
                    index: index,
                  );
                })
            : const NoTaskWidget(),
      ),
    );
  }
}
