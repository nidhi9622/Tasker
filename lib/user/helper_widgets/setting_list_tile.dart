import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
      onTap: () async {
        dynamic uri =
            Uri.parse("https://www.wedigtech.com/terms-and-conditions");
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          // print("can't launch");
        }
      },
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Icon(
          Icons.privacy_tip_outlined,
          color: Colors.red[200],
        ),
      ),
      title: Text('terms'.tr),
      subtitle: subTitle==''?const SizedBox.shrink():Text('changeTheme'.tr),
      trailing: const Icon(Icons.arrow_forward_ios_outlined),
    );
}
