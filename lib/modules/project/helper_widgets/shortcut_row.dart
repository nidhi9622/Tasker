import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app_utils/shared_prefs/get_prefs.dart';
import '../../dashboard/helper_methods/search.dart';
import '../controller/project_detail_controller.dart';

class ShortcutRow extends StatefulWidget {
  final Map object;

  const ShortcutRow({Key? key, required this.object}) : super(key: key);

  @override
  State<ShortcutRow> createState() => _ShortcutRowState();
}

class _ShortcutRowState extends State<ShortcutRow> {
  TextEditingController shortcutController = TextEditingController();
  ProjectDetailController controller = Get.put(ProjectDetailController());

  getData() async {
    if (GetPrefs.containsKey('${widget.object['title']} searchShortcut')) {
      var searchString =
      GetPrefs.getString('${widget.object['title']} searchShortcut');
      controller.searchShortcut.value = jsonDecode(searchString);
    }
  }

  @override
  dispose() {
    super.dispose();
    shortcutController.dispose();
  }
List searchList=[];
  @override
  void initState() {
    if (GetPrefs.containsKey(GetPrefs.projects)) {
      var map = GetPrefs.getString(GetPrefs.projects);
      searchList = jsonDecode(map);
    }
    getData();
    controller.containerWidth.value = 0.70;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Obx(() => Row(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
                height: 40,
                child: controller.searchShortcut.value.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.searchShortcut.value.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              showSearch(
                                  context: context,
                                  delegate: Search(
                                      text:
                                          '${controller.searchShortcut.value[index]}', totalProjectList: searchList));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text(
                                  controller.searchShortcut.value[index],
                                  style: const TextStyle(color: Colors.green),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            ),
                          );
                        })
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'shortSearch'.tr,
                          textAlign: TextAlign.end,
                        ),
                      )),
          ),
          const SizedBox(width: 6),
          InkWell(
              onTap: () {
                controller.containerWidth.value = 0.58;
                controller.isAdded.value = true;
              },
              child: controller.isAdded.value
                  ? Container(
                      width: 70,
                      constraints: const BoxConstraints(maxHeight: 50),
                      decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 3,
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          controller: shortcutController,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: 17,
                      backgroundColor: Colors.green,
                      child: Icon(
                        CupertinoIcons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
          const SizedBox(width: 6),
          InkWell(
            onTap: () async {
              if (shortcutController.text.isNotEmpty) {
                controller.searchShortcut.value.add(shortcutController.text);
                GetPrefs.setString(
                    '${widget.object['title']} searchShortcut',
                    jsonEncode(controller.searchShortcut.value));
              }
              controller.isAdded.value = false;
              // AppRoutes.go(AppRouteName.projectDetail,
              //     arguments: {'object': widget.object});
            },
            child: Container(
              constraints: const BoxConstraints(maxHeight: 80),
              decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'done'.tr,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ));
}
