import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData leadingIcon;
  final String subTitle;

  const SettingListTile(
      {Key? key,
      required this.title,
      required this.onTap,
      required this.leadingIcon,required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(
          leadingIcon,
          color: Colors.red[200],
        ),
      ),
      title: Text(title),
      subtitle: subTitle==''?const SizedBox.shrink():Text(subTitle),
      trailing: const Icon(Icons.arrow_forward_ios_outlined),
    );
}
