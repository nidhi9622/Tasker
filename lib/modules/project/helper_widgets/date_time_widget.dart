import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimeWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isDate;

  const DateTimeWidget(
      {Key? key, required this.onTap, required this.text, required this.isDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(left: 17),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).primaryColor),
            child: Row(
              children: [
                Icon(
                  isDate ? CupertinoIcons.calendar : CupertinoIcons.time_solid,
                  color: Theme.of(context).primaryColorDark,
                ),
                const SizedBox(width: 8),
                Text(text)
              ],
            ),
          ),
        ),
      );
}
