import 'package:flutter/material.dart';
import '../../app_utils/app_routes.dart';

class ProcessWidget extends StatelessWidget {
  final String text;
  final Color containerColor;
  final Color bubbleColor;
  final IconData icon;
  final List object;

  const ProcessWidget(
      {Key? key,
      required this.text,
      required this.containerColor,
      required this.bubbleColor,
      required this.icon,
      required this.object})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize=MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        AppRoutes.go(AppRouteName.processDetail, arguments: {
          'object': object,
          "title": text,
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  width: deviceSize.width * 0.444,
                  height: deviceSize.height * 0.10,
                  decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(15)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: bubbleColor,
                radius: 17,
                child: Icon(
                  icon,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
