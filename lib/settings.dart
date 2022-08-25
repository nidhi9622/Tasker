import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const platform=MethodChannel('message');
  Future getMessage()async{
    await platform.invokeMethod('getMessage');
  }
  @override
  Widget build(BuildContext context) {
    final deviceSize=MediaQuery.of(context).size;
    return Scaffold(appBar: AppBar(elevation:0,backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColorDark,),
        onPressed: (){Navigator.of(context).pop();},),
      title: Text('setting'.tr,style: TextStyle(color: Theme.of(context).primaryColorDark),),),
      body: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          children: [
            Container(width: deviceSize.width,height: deviceSize.height*0.40,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(20),),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                  padding:const EdgeInsets.only(top: 14,bottom: 5,left: 20),
                  child: Text('customize'.tr,textAlign: TextAlign.start,style: const TextStyle(fontWeight: FontWeight.bold),),
                ),
                //SizedBox(height: deviceSize.height*0.01,),
                ListTile(onTap:()async{ await _showDialogThemeBox(context);
                },leading: CircleAvatar(backgroundColor: Colors.grey[200],child: Icon(Icons.format_paint_rounded,color: Colors.red[200],),),
                    title:  Text('Appearance'.tr),subtitle:  Text('changeTheme'.tr),trailing: const Icon(Icons.arrow_forward_ios_outlined),),
                //SizedBox(height: deviceSize.height*0.01,),
                ListTile(onTap:()async{await _showDialogLanguageBox(context);
                },leading: CircleAvatar(backgroundColor: Colors.grey[200],child: Icon(Icons.abc,color: Colors.red[200],),),
                  title: Text('Language'.tr),subtitle: Text('setLanguage'.tr),trailing: const Icon(Icons.arrow_forward_ios_outlined),),
                //SizedBox(height: deviceSize.height*0.01,),
                ListTile(onTap:(){
                  AppSettings.openNotificationSettings();
                },
                  leading: CircleAvatar(backgroundColor: Colors.grey[200]!,child:Icon(Icons.calendar_month_outlined,color:Colors.red[200]),),
                  title: Text('reminderHn'.tr),subtitle: Text('customizeReminder'.tr),trailing:const Icon(Icons.arrow_forward_ios_outlined),),

              ],),
            ),
            SizedBox(height: deviceSize.height*0.04),
            Container(width: deviceSize.width,height: deviceSize.height*0.25,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(20),),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Padding(
                  padding:const EdgeInsets.only(top: 14,bottom: 5,left: 20),
                  child: Text('help'.tr,textAlign: TextAlign.start,style:const TextStyle(fontWeight: FontWeight.bold)),
                ),
                ListTile(onTap:()async{
                  dynamic uri = Uri.parse("https://www.wedigtech.com/terms-and-conditions");
                  if (await canLaunchUrl(uri)){
                    await launchUrl(uri,mode: LaunchMode.externalApplication,);
                  } else {
                   // print("can't launch");
                  }
                },leading: CircleAvatar(backgroundColor: Colors.grey[200],child: Icon(Icons.privacy_tip_outlined,color:Colors.red[200],),),
                  title:  Text('terms'.tr),trailing: const Icon(Icons.arrow_forward_ios_outlined),),
                SizedBox(height: deviceSize.height*0.01,),
                ListTile(onTap:()async{
                  dynamic uri = Uri.parse("https://www.wedigtech.com/privacy-policy");
                  if (await canLaunchUrl(uri)){
                    await launchUrl(uri,mode: LaunchMode.externalApplication);
                  } else {
                   // print("can't launch");
                  }
                },leading: CircleAvatar(backgroundColor: Colors.grey[200],child: Icon(Icons.security,color:Colors.red[200],),),
                  title: Text('policy'.tr),trailing: const Icon(Icons.arrow_forward_ios_outlined),),
                ],),
            )
          ],
        ),
      ),
    );
  }
}
_showDialogLanguageBox(BuildContext context){
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('appLanguage'.tr),
        content:SizedBox(height: 130,
          child: Column(children: [
            dialogTile(context, 'English', ()async{
              var locale=const Locale('en');
              Get.updateLocale(locale);
              Navigator.of(context).pop();
              }),
            dialogTile(context, 'हिन्दी', ()async{
              var locale=const Locale('hindi');
              Get.updateLocale(locale);
              Navigator.of(context).pop();
            })
          ],),
        )
      );
    },
  );
}
_showDialogThemeBox(BuildContext context){
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title:  Text('theme'.tr),
        content:SizedBox(height: 130,
          child: Column(children: [
            dialogTile(context, 'Dark', ()async{
              SharedPreferences preferences=await SharedPreferences.getInstance();
              preferences.setBool('theme',false);
              Get.changeThemeMode(ThemeMode.dark);
              Navigator.of(context).pop();
            }),
            dialogTile(context, 'Light', ()async{
              SharedPreferences preferences=await SharedPreferences.getInstance();
              preferences.setBool('theme',true);
              Get.changeThemeMode(ThemeMode.light);
              Navigator.of(context).pop();
            })
          ],),
        ) ,
      );
    },
  );
}
dialogTile(BuildContext context,String text,dynamic onTap){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(color: Theme.of(context).scaffoldBackgroundColor,
      child: TextButton(
        onPressed:onTap,
        child: Center(child: Text(text,style: TextStyle(color:Theme.of(context).primaryColorDark),)),
      ),
    ),
  );
}
