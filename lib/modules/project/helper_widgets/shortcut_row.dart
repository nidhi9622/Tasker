import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dashboard/helper_methods/search.dart';

class ShortcutRow extends StatefulWidget {
  final Map object;

  const ShortcutRow({Key? key, required this.object}) : super(key: key);

  @override
  State<ShortcutRow> createState() => _ShortcutRowState();
}

class _ShortcutRowState extends State<ShortcutRow> {
  bool isAdded = false;

  double containerWidth = 0.67;
  List searchShortcut = [];
  TextEditingController shortcutController = TextEditingController();

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('${widget.object['title']} searchShortcut')) {
      var searchString =
          preferences.getString('${widget.object['title']} searchShortcut');
      setState(() {
        searchShortcut = jsonDecode(searchString!);
      });
    }
  }
  @override
  dispose() {
    super.dispose();
    shortcutController.dispose();
  }
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: SizedBox(
              height: 40,
              child: searchShortcut.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: searchShortcut.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate:
                                    Search(text: '${searchShortcut[index]}'));
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
                                searchShortcut[index],
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
              setState(() {
                containerWidth = 0.58;
                isAdded = true;
              });
            },
            child: isAdded
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
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              searchShortcut.add(shortcutController.text);
              preferences.setString('${widget.object['title']} searchShortcut',
                  jsonEncode(searchShortcut));
            }
            setState(() {
              isAdded = false;
            });
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
    );
  }
}
