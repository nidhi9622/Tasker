import 'package:flutter/material.dart';

class ExploreOptions extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String text;
  const ExploreOptions({Key? key, required this.onTap, required this.iconData, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size deviceSize=MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: deviceSize.width * 0.26,
        height: deviceSize.height * 0.11,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Colors.red[200],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
