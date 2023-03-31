import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app_utils/app_routes.dart';
import '../../../app_utils/global_data.dart';

class AddProjectWidget extends StatefulWidget {
  const AddProjectWidget({Key? key}) : super(key: key);

  @override
  State<AddProjectWidget> createState() => _AddProjectWidgetState();
}

class _AddProjectWidgetState extends State<AddProjectWidget> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                selectIndex.value = 2;
                AppRoutes.go(AppRouteName.bottomNavPage);
              },
              child: Row(
                children: [
                  Text(
                    'addProject'.tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CircleAvatar(
                      backgroundColor: Colors.red[200],
                      radius: 13,
                      child: const Icon(
                        CupertinoIcons.add,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            InkWell(
              onTap: () {
                selectIndex.value = 1;
                AppRoutes.go(AppRouteName.bottomNavPage);
              },
              child: Text(
                'allProject'.tr,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      );
}
