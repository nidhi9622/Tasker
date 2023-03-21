import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/app_utils/common_app_bar.dart';
import 'package:task_manager/user/helper_widgets/custom_url_launcher.dart';
import 'package:task_manager/user/helper_widgets/setting_list_tile.dart';
import '../helper_widgets/box_dialog.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: CommonAppBar(
        text: 'setting'.tr,
        onTap: () {},
        isLeading: true,
        isAction: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 18, bottom: 8, left: 20),
                    child: Text(
                      'customize'.tr,
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                    ),
                  ),
                  SettingListTile(
                    title: 'Appearance'.tr,
                    onTap: () async {
                      await boxDialog(
                        context: context,
                        titleText: 'theme'.tr,
                        tileTextFirst: 'Dark',
                        tileTextSecond: 'Light',
                        tileTapFirst: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setBool('theme', false);
                          Get.changeThemeMode(ThemeMode.dark);
                          Navigator.of(context).pop();
                        },
                        tileTapSecond: () async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          preferences.setBool('theme', true);
                          Get.changeThemeMode(ThemeMode.light);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    leadingIcon: CupertinoIcons.paintbrush,
                    subTitle: 'changeTheme'.tr,
                  ),
                  SettingListTile(
                      title: 'Language'.tr,
                      onTap: () async {
                        await boxDialog(
                            context: context,
                            titleText: 'appLanguage'.tr,
                            tileTextFirst: 'English',
                            tileTextSecond: 'हिन्दी',
                            tileTapFirst: () async {
                              var locale = const Locale('en');
                              Get.updateLocale(locale);
                              Navigator.of(context).pop();
                            },
                            tileTapSecond: () async {
                              var locale = const Locale('hindi');
                              Get.updateLocale(locale);
                              Navigator.of(context).pop();
                            });
                      },
                      leadingIcon: Icons.abc,
                      subTitle: 'setLanguage'.tr),
                  SettingListTile(
                      title: 'reminderHn'.tr,
                      onTap: () {
                        AppSettings.openNotificationSettings();
                      },
                      leadingIcon: CupertinoIcons.calendar,
                      subTitle: 'customizeReminder'.tr),
                  const SizedBox(height: 12,)
                ],
              ),
            ),
            const SizedBox(height: 25),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14, bottom: 5, left: 20),
                    child: Text('help'.tr,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SettingListTile(
                    title: 'terms'.tr,
                    onTap: customLaunchUrl,
                    leadingIcon: Icons.privacy_tip_outlined,
                    subTitle: '',
                  ),
                  SettingListTile(
                    title: 'policy'.tr,
                    onTap: customLaunchUrl,
                    leadingIcon: Icons.security,
                    subTitle: '',
                  ),
                  const SizedBox(height: 12,)
                ],
              ),
            )
          ],
        ),
      ),
    );
}
