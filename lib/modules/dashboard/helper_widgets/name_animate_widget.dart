import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app_utils/app_routes.dart';
import '../helper_methods/greeting_message.dart';

class NameAnimateWidget extends StatefulWidget {
  final String username;

  const NameAnimateWidget({Key? key, required this.username}) : super(key: key);

  @override
  State<NameAnimateWidget> createState() => _NameAnimateWidgetState();
}

class _NameAnimateWidgetState extends State<NameAnimateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.username.isNotEmpty
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 25),
            child: Text(
              '${greetingMessage()},  ${widget.username}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
        : Container(
            width: double.infinity,
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 15,),
            child: InkWell(
              onTap: () {
                AppRoutes.go(AppRouteName.updateUserProfile);
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FadeTransition(
                      opacity: controller,
                      child: Text('addProfile'.tr,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  SizedBox(
                      child: Text(
                        textAlign: TextAlign.end,
                        'tap'.tr,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ))
                ],
              ),
            ),
          );
}
