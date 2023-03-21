import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/project/helper_widgets/indicator_widget.dart';
import 'package:task_manager/ui_utils/no_task_widget.dart';
import '../../app_utils/app_routes.dart';
import '../../models/data_model.dart';

class ProcessDetailView extends StatelessWidget {
  final List tabList;

  const ProcessDetailView({Key? key, required this.tabList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        padding: const EdgeInsets.only(left: 14, right: 14),
        child: tabList.isNotEmpty
            ? ListView.builder(
                itemCount: tabList.length,
                itemBuilder: (context, index) {
                  DataModel dataModel = DataModel(tabList[index]);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        AppRoutes.go(AppRouteName.projectDetail,
                            arguments: {'object': tabList[index]});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 18, left: 18, bottom: 18),
                        width: deviceSize.width,
                        height: 128,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor),
                        child: Row(
                          children: [
                            SizedBox(
                              width: deviceSize.width * 0.60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataModel.title!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  SizedBox(height: deviceSize.height * 0.01),
                                  Text(dataModel.subtitle!,
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                  SizedBox(height: deviceSize.height * 0.02),
                                  Row(
                                    children: [
                                      const Icon(
                                        CupertinoIcons.calendar,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: deviceSize.width * 0.02,
                                      ),
                                      Text(
                                        dataModel.date,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            IndicatorWidget(dataModel: dataModel),
                          ],
                        ),
                      ),
                    ),
                  );
                })
            : const NoTaskWidget(),
      ),
    );
  }
}
