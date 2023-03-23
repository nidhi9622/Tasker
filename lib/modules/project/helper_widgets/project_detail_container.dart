import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_manager/models/data_model.dart';
import '../../../app_utils/app_routes.dart';
import 'shortcut_row.dart';

class ProjectDetailContainer extends StatelessWidget {
  final Map object;
  final double totalPercentage;
  final DataModel dataModel;

  const ProjectDetailContainer(
      {Key? key,
      required this.object,
      required this.totalPercentage,
      required this.dataModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
            ),
            color: Theme.of(context).primaryColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${dataModel.title}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                IconButton(
                    onPressed: () {
                      AppRoutes.go(AppRouteName.editTask, arguments: {
                        'object': object,
                      });
                    },
                    icon: const Icon(CupertinoIcons.pen))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                '${dataModel.subtitle}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: CircularPercentIndicator(
                    radius: 44,
                    center: Text(
                      '${totalPercentage.round()} %',
                      style: const TextStyle(fontSize: 17),
                    ),
                    animation: true,
                    animationDuration: 1000,
                    percent: totalPercentage < 101
                        ? totalPercentage / 100
                        : 100 / 100,
                    progressColor: Colors.green,
                    backgroundColor: Colors.grey[300]!,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'status'.tr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Text(dataModel.status!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(width: 10),
                  ],
                )
              ],
            ),
            ShortcutRow(
              object: object,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ));
  }
}
