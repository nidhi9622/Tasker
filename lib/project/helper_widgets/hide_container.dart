import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HideContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const HideContainer({Key? key, required this.onTap, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize=MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Container(
          width: double.infinity,
          height: 30,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Theme.of(context).primaryColor),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.red[200],
                radius: 9,
                child: Icon(
                  CupertinoIcons.add,
                  color: Theme.of(context).primaryColor,
                  size: 17,
                ),
              ),
              SizedBox(width: deviceSize.width * 0.015),
              Text(
                text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
