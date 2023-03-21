import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future titleErrorDialog(
    {required BuildContext context,
    required String content,
    required bool isTitle}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
        title: isTitle ? Text('Update'.tr) : const SizedBox.shrink(),
        content: Text(content),
        actions: [
          TextButton(
            child: Center(child: Text('ok'.tr)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
  );
}
