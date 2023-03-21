import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_utils/app_routes.dart';
import '../views/home_page.dart';

class AddProjectWidget extends StatefulWidget {
  const AddProjectWidget({Key? key}) : super(key: key);

  @override
  State<AddProjectWidget> createState() => _AddProjectWidgetState();
}

class _AddProjectWidgetState extends State<AddProjectWidget> {
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding:
      const EdgeInsets.only(left: 20, top: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectIndex = 2;
              });
              AppRoutes.go(AppRouteName.homePage);
            },
            child: SizedBox(
              width: deviceSize.width * 0.44,
              child: Row(
                children: [
                  Text(
                    'addProject'.tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: deviceSize.width * 0.02),
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
          ),
          SizedBox(
            width: deviceSize.width * 0.45,
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
}
