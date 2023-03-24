import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:task_manager/modules/dashboard/helper_widgets/popup_sheet.dart';
import '../../../app_utils/app_routes.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../../../models/data_model.dart';
import '../controller/dashboard_controller.dart';

class ProjectItemList extends StatefulWidget {
  final DashboardController controller;

  const ProjectItemList({Key? key, required this.controller}) : super(key: key);

  @override
  State<ProjectItemList> createState() => _ProjectItemListState();
}

class _ProjectItemListState extends State<ProjectItemList> {
  @override
  Widget build(BuildContext context) => Obx(
        () => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.controller.projectList.value.length,
          itemBuilder: (context, index) {
            DataModel dataModel =
                DataModel.fromJson(widget.controller.projectList.value[index]);
            return Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    left: 22, right: 22, bottom: 12, top: 6),
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                      onTap: () {
                        AppRoutes.go(AppRouteName.projectDetail, arguments: {
                          'object': widget.controller.projectList.value[index]
                        });
                      },
                      leading: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: dataModel.percentage! < 100
                                    ? Colors.grey
                                    : Colors.green),
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(
                          CupertinoIcons.checkmark,
                          color: dataModel.percentage! < 100
                              ? Colors.grey
                              : Colors.green,
                        ),
                      ),
                      title: Text(dataModel.title!),
                      subtitle: LinearPercentIndicator(
                        //leaner progress bar
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 10.0,
                        percent: dataModel.percentage! / 100,
                        progressColor: dataModel.percentage! < 100
                            ? const Color(0xffffb2a6)
                            : Colors.green,
                        barRadius: const Radius.circular(10),
                        backgroundColor: Colors.grey[300],
                      ),
                      trailing: PopupSheet(
                        onTapFirst: () {
                          AppRoutes.pop();
                          AppRoutes.go(AppRouteName.editTask, arguments: {
                            'object': widget.controller.projectList.value[index]
                          });
                        },
                        onTapSecond: () async {
                          GetPrefs.remove('${dataModel.id}');
                          widget.controller.projectList.value.removeWhere(
                              (element) => element['id'] == dataModel.id);
                          GetPrefs.setString(GetPrefs.projects,
                              jsonEncode(widget.controller.projectList.value));
                        },
                      )),
                ));
          },
        ),
      );
}
