import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void deleteBottomSheet({
  required BuildContext context,
  required String title,
  required int index,
  required VoidCallback onTapEdit,
  required VoidCallback onTapDelete,
}) =>
    showModalBottomSheet(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        context: context,
        builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: onTapEdit,
                    child: ListTile(
                      title: const Text('Edit'),
                      trailing: const Icon(CupertinoIcons.pen),
                      tileColor: Colors.grey[350],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap:onTapDelete,
                      child: ListTile(
                        title: const Text('Delete'),
                        trailing: const Icon(CupertinoIcons.delete),
                        tileColor: Colors.grey[350],
                      )),
                ],
              ),
            ));
