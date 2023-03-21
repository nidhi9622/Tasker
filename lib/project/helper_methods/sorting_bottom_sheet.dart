import 'package:flutter/material.dart';

void sortingBottomSheet(
    {required BuildContext context,
    required Size deviceSize,
    required VoidCallback ascendingSort,
    required VoidCallback descendingSort}) {
  showModalBottomSheet(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      backgroundColor: Colors.grey[350],
      builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            height: deviceSize.height * 0.13,
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    ascendingSort();
                  },
                  child: SizedBox(
                    width: deviceSize.width,
                    height: deviceSize.height * 0.05,
                    child: const Center(
                      child: Text(
                        "Sort : A-Z",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      descendingSort();
                    },
                    child: SizedBox(
                      width: deviceSize.width,
                      height: deviceSize.height * 0.05,
                      child: const Center(
                        child: Text('Sort : Z-A',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ),
                    ))
              ],
            ),
          ),
        ));
}
