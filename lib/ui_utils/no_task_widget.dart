import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoTaskWidget extends StatelessWidget {
  const NoTaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'noTask'.tr,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xfffc7474)),
          ),
          const SizedBox(height: 4),
          Text(
            'noTaskText'.tr,
            style: TextStyle(color: Colors.red[200], fontSize: 17),
          )
        ],
      );
}
