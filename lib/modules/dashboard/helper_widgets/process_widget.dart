import 'package:flutter/material.dart';
import '../../../app_utils/app_routes.dart';

class ProcessWidget extends StatelessWidget {
  final String text;
  final Color containerColor;
  final Color bubbleColor;
  final IconData icon;
  final String status;

  const ProcessWidget(
      {Key? key,
      required this.text,
      required this.containerColor,
      required this.bubbleColor,
      required this.icon,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => AppRoutes.go(AppRouteName.processDetail, arguments: {
            'object': status,
            "title": text,
          }),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 84,
            decoration: BoxDecoration(
                color: containerColor, borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  CircleAvatar(
                    backgroundColor: bubbleColor,
                    radius: 17,
                    child: Icon(
                      icon,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
