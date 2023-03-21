import 'package:flutter/material.dart';
import '../../app_utils/app_routes.dart';

Future<void> sortingBottomSheet(
    {required BuildContext context,
    required VoidCallback ascendingSort,
    required VoidCallback descendingSort}) async {
  await showModalBottomSheet(
      elevation: 5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))),
      context: context,
      backgroundColor: Colors.grey[350],
      builder: (BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              AppRoutes.pop();
              ascendingSort();
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 14,bottom: 10),
              child: SizedBox(width: double.infinity,
                child: Center(
                  child: Text(
                    "Sort : A-Z",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const Divider(thickness: 1),
          InkWell(
              onTap: () async {
                AppRoutes.pop();
                descendingSort();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 10,bottom: 14),
                child: SizedBox(width: double.infinity,
                  child: Center(
                    child: Text('Sort : Z-A',
                        style:
                            TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ),
              ))
        ],
      ));
}
