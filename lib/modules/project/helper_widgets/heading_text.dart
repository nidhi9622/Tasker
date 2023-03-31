import 'package:flutter/material.dart';

class HeadingText extends StatelessWidget {
  final String text;

  const HeadingText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).primaryColor,
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.only(
          top: 13,
          left: 14,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
          ),
        ));
}
