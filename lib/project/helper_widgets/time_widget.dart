import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimeWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isDate;
  const DateTimeWidget({Key? key, required this.onTap, required this.text, required this.isDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize=MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.only(left: 17),
          width: deviceSize.width,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor),
          child: Row(
            children: [
              Icon(
                isDate?CupertinoIcons.calendar:CupertinoIcons.time_solid,
                color: Theme.of(context).primaryColorDark,
              ),
              SizedBox(width: deviceSize.width * 0.025),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}
