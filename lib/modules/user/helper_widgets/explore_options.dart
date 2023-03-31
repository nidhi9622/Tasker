import 'package:flutter/material.dart';

class ExploreOptions extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String text;

  const ExploreOptions(
      {Key? key,
      required this.onTap,
      required this.iconData,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17),
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
              height: 7,
            ),
            Text(text)
          ],
        ),
      ),
    );
}
